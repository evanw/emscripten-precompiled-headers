#include "common.h"
#include "json.h"

static const char *data =
"{\n"
"  \"glossary\": {\n"
"    \"title\": \"example glossary\",\n"
"    \"GlossDiv\": {\n"
"      \"title\": \"S\",\n"
"      \"GlossList\": {\n"
"        \"GlossEntry\": {\n"
"          \"ID\": \"SGML\",\n"
"          \"SortAs\": \"SGML\",\n"
"          \"GlossTerm\": \"Standard Generalized Markup Language\",\n"
"          \"Acronym\": \"SGML\",\n"
"          \"Abbrev\": \"ISO 8879:1986\",\n"
"          \"GlossDef\": {\n"
"            \"para\": \"A meta-markup language, used to create markup languages such as DocBook.\",\n"
"            \"GlossSeeAlso\": [\"GML\", \"XML\"]\n"
"          },\n"
"          \"GlossSee\": \"markup\"\n"
"        }\n"
"      }\n"
"    }\n"
"  }\n"
"}";

int main() {
  Json::Value value;
  Json::Reader reader;
  reader.parse(data, value);
  std::cout << value.toStyledString() << std::endl;
  return 0;
}
