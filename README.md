# graphql2code

flutter 的graphql蛮难用的，查询语句写在字符串里可还行，又没提示又不好看。

一个将graphql文件自动化生成代码的轻量级dart脚本文件.

适用于需要在flutter项目中集成graphql的童鞋们！

## Getting Started

1、`pubspec.yaml`中引入项目依赖
```
 
dependencies:
  flutter:
    graphql2code:^0.0.1
    
```


2、再喜欢的目录里面新建一个dart文件，然后放入执行脚本入口

> GraphqlGenerate().gen(graphqlPath,mobanPath,savePath);  
>第一个参数为：graphql的文件所在目录，支持子目录遍历
>第二个参数为：模版文件所在的目录（模版往下看）
>第三个参数为: 你需要将生成的代码文件保存在哪个目录

>PS：路径需以项目目录为参考，而不是文件所在目录
```dart

//将graphql文件生成对应string脚本
void main() {
  //执行生成代码:
  
  GraphqlGenerate().gen("/lib/graphql/graphql", "/lib/graphql/gen_moban.txt",
      "/lib/graphql/result.dart");
}

```

#### 3、模版语法

1. 模版文件中需要包含一个  `<gen> Any script </gen>`。
2. `<gen>`标签对中的内容将被替换
3. `<gen>`标签对中可以使用  `$tag$`(会被替换为query 或者 mutation 等标签)、`$name$`(会被替换成语句名)、`$content$`（会被替换成完整的graphql语句）占位符


>模版文件例子：
```text
class Test{
 
   <gen>
   const String $name$ = r'''
   $content$
   ''';
   </gen>   
 
}
```



#### 4、点击定义的生成脚本`main()`方法旁边的绿色小箭头运行就可以了。

#### 使用参考：可以参考test目录中的脚本例子
>PS、通常报错都是路径问题。



