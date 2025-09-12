import json

# 示例 JSON 数据
with open('../en-US.json', 'r', encoding='utf-8') as file:
    nested_json = json.load(file)


lowercase_data = {key.lower(): value for key, value in nested_json.items()}

# 输出结果
with open('en-US-lowercase_data.json', 'w', encoding='utf-8') as file:
    json.dump(lowercase_data, file, ensure_ascii=False, indent=4)
