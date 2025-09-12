import json

def flatten_json(nested_json, parent_key='', sep='.'):
    """
    将嵌套的 JSON 扁平化。
    :param nested_json: 需要扁平化的 JSON 对象（字典）
    :param parent_key: 用于拼接父级键的字符串
    :param sep: 用于分隔键名的字符（默认为'.'）
    :return: 扁平化后的 JSON 对象
    """
    items = []
    
    for key, value in nested_json.items():
        new_key = f"{parent_key}{sep}{key}" if parent_key else key
        
        if isinstance(value, dict):
            # 如果值是字典，递归调用 flatten_json
            items.extend(flatten_json(value, new_key, sep=sep).items())
        else:
            # 否则直接添加键值对
            items.append((new_key, value))
    
    return dict(items)

# 示例 JSON 数据
with open('../zh-CN.json', 'r', encoding='utf-8') as file:
    nested_json = json.load(file)

# 扁平化 JSON 数据
flattened_json = flatten_json(nested_json)

# 输出结果

with open('zh-CN-flatten.json', 'w', encoding='utf-8') as file:
    json.dump(flattened_json, file, ensure_ascii=False, indent=4)
