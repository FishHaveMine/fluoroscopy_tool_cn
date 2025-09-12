import json

# 读取 JSON 文件
with open("op.json", "r", encoding="utf-8") as file:
    data = json.load(file)

# 解析并转换格式
result = {}
if "compressorRestartWaitTime" in data:
    for index, item in enumerate(data["compressorRestartWaitTime"]):
        result[f"compressorRestartWaitTime{index}"] = item["label"]

# **将结果写入新的 JSON 文件**
with open("output.json", "w", encoding="utf-8") as out_file:
    json.dump(result, out_file, indent=4, ensure_ascii=False)

print("转换完成，数据已保存到 output.json")
