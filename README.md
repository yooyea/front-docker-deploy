在 Ubuntu 操作系统的部署操作

使用 envsubst 命令生成 nginx 配置文件，配置文件中用到了前端打包生成的存储服务器地址

配置文件中还用到了前端打包生成的版本号

前端打包生成文件主要用了 webpack 插件 generate-asset-webpack-plugin 

sudo sh build.sh [git 分支名] 运行即可

但该 shell 脚本里涉及到了 git 版本的判断，所以 git 分支名必填

还封了 1 个可选参数： 指定部署后的服务运行端口，默认是 9900

而且 nginx 还配置了接口代理转发以解决跨域问题，这就是上面所说用到服务器地址的原因所在

nginx 还配置了开启压缩服务，主要由前端打包时使用 compression-webpack-plugin 插件达到 gzip 压缩效果

build.sh 为主要 构建 docker 镜像的脚本，其中实际上只有 docker build 那行为构建 docker 行为，其它都为自定义配置 自行理解和改造



最终 构建成功后会使用 docker-compose 将 docker 服务运行起来， docker-compose.yml 为 主要运行 docker 的配置文件，其中主要参数自行查看官方文档理解其中意义

static_source 为 前端打包前后 public 文件夹里的文件夹，里面可以放上自定义所需的 静态资源文件，映射在 docker 外部可随时替换更改，具体查看 docker volume 参数 