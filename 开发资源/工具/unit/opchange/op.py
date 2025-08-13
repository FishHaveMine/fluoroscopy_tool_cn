import json

# 读取 JSON 文件
with open("op.json", "r", encoding="utf-8") as file:
    data = json.load(file)

# 存储转换后的数据
result = {}

# 遍历 JSON 数据的所有属性
for key, value in data.items():
    # 只处理 **数组类型** 且包含 "label" 的对象
    if isinstance(value, list) and all(isinstance(item, dict) and "label" in item for item in value):
        for index, item in enumerate(value):
            result[f"setting_{key}{item["value"]}"] = item["label"]
    else:
        # 直接复制非数组项
        result[key] = value

# **写入新的 JSON 文件**
with open("output.json", "w", encoding="utf-8") as out_file:
    json.dump(result, out_file, indent=4, ensure_ascii=False)

print("转换完成，数据已保存到 output.json")



# 存储转换后的数据
new_result = {}

# 遍历 JSON 数据的所有属性
for key, value in data.items():
    # 如果值是数组，并且包含字典对象
    if isinstance(value, list) and all(isinstance(item, dict) for item in value):
        new_result[key] = []
        for index, item in enumerate(value):
            # 创建新的数据结构，label 和 name 替换成 tr(...)
            new_item = {
                "label": f'"setting_{key}{item["value"]}")',
                "name": f'tr("setting_{key}{item["value"]}")',
            }
            # 复制原有的其他字段
            new_item.update({k: v for k, v in item.items() if k not in ["label", "name"]})
            new_result[key].append(new_item)
    else:
        # 直接复制非数组项
        new_result[key] = value

# **写入新的 JSON 文件**
with open("new_output.json", "w", encoding="utf-8") as out_file:
    json.dump(new_result, out_file, indent=4, ensure_ascii=False)

print("转换完成，数据已保存到 new_output.json")