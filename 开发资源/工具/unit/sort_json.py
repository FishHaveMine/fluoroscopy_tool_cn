import json

# 读取en-US.json和zh-CM.json
with open('en-US.json', 'r', encoding='utf-8') as file:
    en_us = json.load(file)
    
with open('zh-CN.json', 'r', encoding='utf-8') as file:
    zh_cm = json.load(file)
# 将en-US的内容按zh-CM的顺序排列
result = {}

# 按zh-CM的顺序排列
for key in zh_cm:
    if key in en_us:
        result[key] = en_us[key]

# # 将en-US中没有在zh-CM中出现的元素放到最后
# for key in en_us:
#     if key not in zh_cm:
#         result[key] = en_us[key]

# 输出结果到一个新的JSON文件
with open('sorted_en-US.json', 'w', encoding='utf-8') as file:
    json.dump(result, file, ensure_ascii=False, indent=4)

print("排序完成，结果保存到sorted_en-US.json")
