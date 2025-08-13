<!--
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-05-27 14:42:22
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-12 10:54:55
 * @FilePath: /fluoroscopy_tool/README.md
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->

# fluoroscopy_tool 内销开发版(水机模块)

氟机开发app，只支持串口连接

## Getting Started

环境配置： /lib/config_dev.dart   or   /lib/config_prod.dart

本地资源：

### public/html/testRunReport.html

 本地试运行报告运行模板
### assets/translations/

 本地多语言文件，第一次加载app先加载本地语言版本，当联网后缓存云端的多语言版本在第二次进入后自动使用缓存的云端版本
### public/images/

 本地图片
### lib/view/local

 本地功能入口
### lib/view/cloud

 云端功能入口
### app维护更新支持  btri-dev -- iBUILDING

### app版本控制:

https://btri-dev.midea.com/btri-update-log/apps/list/version?appId=fluoroscopy_tool

### 接口说明:

https://btri-dev.midea.com/api/apps-version-manager/swagger-ui.html#/app%E7%AB%AF%E4%BD%BF%E7%94%A8/getLatestAppsVersionUsingPOST_1
https://confluence.midea.com/pages/viewpage.action?pageId=45662588

### 多语言管理:

https://btri-dev.midea.com/web/oam/open/i18n/space/phrase?spaceId=1000&category=0&lagnguageCode=fluoroscopy_tool

#### 手机定位支持 locationpage -- 高德地图

#### app打包

测试环境：  flutter build apk --dart-define=ENV=dev
正式环境：  flutter build apk --dart-define=ENV=prod

#### app打包\macbook开发环境下可运行：

正式环境打包.app、测试环境打包.app，使用 Automator 打开，修改里面的项目地址，然后双击运行即可


git checkout cn_waterpumb
git fetch origin
git merge origin/cn_neixiao
