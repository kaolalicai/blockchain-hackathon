# 区块链征信系统
# CamelBit-blockchain-hackathon

### 我们想解决什么问题
在金融行业，征信一直是存在数据孤岛、获取成本高问题.

初始状态：
![img](http://oqln5pzeb.bkt.clouddn.com/18-6-24/94197678.jpg)

当前状态（征信介入）
![img](http://oqln5pzeb.bkt.clouddn.com/18-6-24/68953183.jpg)

本项目解决方案：
![img](http://oqln5pzeb.bkt.clouddn.com/18-6-24/5032964.jpg)

本方案设计的整体设计 
![img](http://oqln5pzeb.bkt.clouddn.com/18-6-24/69224174.jpg)

涉及三个部分（见上图蓝色部分），分别是：

 - 智能合约
 - 征信对接SDK
 - DBLog无缝对接SDK

解决点：

 - 金融征信孤岛：企业数据共享上链
 - 数据获取成本高、渠道分散并有限：公开 blockchain 直接读取
 - 数据隐私保护：对ID类信息（如身份证等）单向hash后上链(类同态加密)
 - 数据质量：真实有用数据加token，假数据扣减token（token不足不再允许读写）

