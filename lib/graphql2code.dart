library graphql2code;

// 通过Graphql生成数据
import 'dart:io';

//将graphql文件生成string的脚本文件
class GraphqlGenerate {
  //生成文件
  void gen(String graphqlPath, String mobanPath, String savePath) {
    Directory current = Directory.current;
    print("当前的文件目录：${current.path}");
    List<_GqlBean> result = [];
    var isBegin = false;
    StringBuffer buffer = StringBuffer();
    var endCount = 0;
    _GqlBean gqlBean;
    //遍历目录
    Directory dir = Directory(current.path + graphqlPath);
    var list = dir.listSync(recursive: true, followLinks: false);
    for (FileSystemEntity entity in list) {
      if (entity.path.endsWith(".graphql")) {
        print("当前目录下文件:${entity.path}");
        File(entity.path).readAsLinesSync().forEach((line) {
          //识别节点
          if (line.startsWith("query")) {
            isBegin = true;
            gqlBean = _GqlBean("query");
          } else if (line.startsWith("mutation")) {
            isBegin = true;
            gqlBean = _GqlBean("mutation");
          }

          //加入识别出的数据
          if (isBegin) {
            buffer.writeln(line);
            endCount += line.count("{");
            endCount -= line.count("}");
          }
          if (endCount == 0 && buffer.toString().length > 0) {
            gqlBean.setContent(buffer.toString());
            result.add(gqlBean);
            buffer.clear();
            isBegin = false;
          }
        });
      }
    }

    //读取模版文件
    File mobanFile = File(current.path + mobanPath);
    String mobanContent = mobanFile.readAsStringSync();
    //获取到的模版内容
    String moban = RegExp(r"<gen>[\s\S]*</gen>")
        .stringMatch(mobanContent)
        .replaceAll(r"<gen>", "")
        .replaceAll(r"</gen>", "");

    //生成文件数据
    StringBuffer saveString = StringBuffer();
    result.forEach((query) {
      saveString.writeln(moban
          .replaceAll(r"$tag$", query.tag)
          .replaceAll(r"$name$", query.name)
          .replaceAll(r"$content$", query.content));
    });
    String mobanResult = mobanContent.replaceAll(
        RegExp(r"<gen>[\s\S]*</gen>"), saveString.toString());

    //保存文件
    File saveFile = File(current.path + savePath);
    saveFile.writeAsStringSync(mobanResult);
  }
}

//---工具类

class _GqlBean {
  String tag;
  String name;
  String content;

  _GqlBean(this.tag, {this.name, this.content});

  void setContent(String content) {
    this.name = content.getGraphqlTagName(this.tag);
    this.content = content;
  }
}

extension _StringExt on String {
  //字符串包含多少次另一个字符串
  int count(String chat) {
    var count = 0;
    var s = this;
    var index = s.indexOf(chat);
    while (index >= 0) {
      count++;
      index = s.indexOf(chat, index + 1);
    }
    return count;
  }

  //提取graphql的标签名称
  String getGraphqlTagName(String tag) {
    var headerIndex = this.indexOf(tag) + tag.length;
    var beginIndex = this.indexOf(RegExp(r"\S"), headerIndex);
    var lastIndex = this.indexOf(RegExp(r"[ |\{]"), beginIndex);
    return this.substring(beginIndex, lastIndex);
  }
}
