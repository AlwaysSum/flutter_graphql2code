import 'package:flutter_test/flutter_test.dart';

import 'package:graphql2code/graphql2code.dart';

void main() {
  test('adds one to input values', () {
    //开始生成
    GraphqlGenerate().gen("/test/graphql", "/test/gen_moban.txt",
        "/test/result.dart");
  });
}
