import json

# 读取 JSON 文件
def load_json(file_path):
    with open(file_path, "r", encoding="utf-8") as f:
        return json.load(f)

# 加载两个 JSON 文件
json1 = load_json("../zh-CN.json")
json2 = load_json("../en-US.json")

# 提取所有的键
keys1 = set(json1.keys())
keys2 = set(json2.keys())

# 找出不同的键
only_in_json1 = keys1 - keys2  # 只在 json1 里有
only_in_json2 = keys2 - keys1  # 只在 json2 里有

print("Keys only in file1.json:", only_in_json1)
print("Keys only in file2.json:", only_in_json2)
