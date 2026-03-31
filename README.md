# 腾讯云监控 Exporter

基于 Prometheus 的腾讯云监控指标导出工具，支持自动发现实例并批量导出云监控指标数据。

![Go Version](https://img.shields.io/badge/go-1.21%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Docker](https://img.shields.io/badge/docker-ghcr.io-blue)

## 特性

- 支持 35+ 款腾讯云产品
- 自动发现并导出产品所有支持的指标
- 实例自动发现，支持按实例 ID 过滤
- 可配置的 API 请求速率限制
- 响应数据缓存，降低 API 调用频次
- 支持 IAM 角色鉴权
- 支持 Docker 与 Kubernetes 部署

## 支持的产品列表

| 产品 | 命名空间 | 指标文档 |
|------|----------|----------|
| 数据库 MongoDB | QCE/CMONGO | [指标详情](https://cloud.tencent.com/document/product/248/45104) |
| 数据库 MySQL (CDB) | QCE/CDB | [指标详情](https://cloud.tencent.com/document/product/248/45147) |
| Redis 内存版 | QCE/REDIS_MEM | [指标详情](https://cloud.tencent.com/document/product/248/49729) |
| 云服务器 CVM | QCE/CVM | [指标详情](https://cloud.tencent.com/document/product/248/6843) |
| 对象存储 COS | QCE/COS | [指标详情](https://cloud.tencent.com/document/product/248/45140) |
| 内容分发网络 CDN | QCE/CDN | [指标详情](https://cloud.tencent.com/document/product/248/45138) |
| 负载均衡 CLB 公网 | QCE/LB_PUBLIC | [指标详情](https://cloud.tencent.com/document/product/248/51898) |
| 负载均衡 CLB 七层 | QCE/LOADBALANCE | [指标详情](https://cloud.tencent.com/document/product/248/45045) |
| 负载均衡 CLB 内网 | QCE/LB_PRIVATE | [指标详情](https://cloud.tencent.com/document/product/248/51899) |
| NAT 网关 | QCE/NAT_GATEWAY | [指标详情](https://cloud.tencent.com/document/product/248/45069) |
| 物理专线 | QCE/DC | [指标详情](https://cloud.tencent.com/document/product/248/45102) |
| 专用通道 | QCE/DCX | [指标详情](https://cloud.tencent.com/document/product/248/45101) |
| 专线网关 | QCE/DCG | [指标详情](https://cloud.tencent.com/document/product/248/45072) |
| CBS 云硬盘 | QCE/CBS | [指标详情](https://cloud.tencent.com/document/product/248/45411) |
| 数据库 SQL Server | QCE/SQLSERVER | [指标详情](https://cloud.tencent.com/document/product/248/45146) |
| 数据库 MariaDB | QCE/MARIADB | [指标详情](https://cloud.tencent.com/document/product/248/54397) |
| Elasticsearch | QCE/CES | [指标详情](https://cloud.tencent.com/document/product/248/45129) |
| 数据库 PostgreSQL | QCE/POSTGRES | [指标详情](https://cloud.tencent.com/document/product/248/45105) |
| CKafka 实例 | QCE/CKAFKA | [指标详情](https://cloud.tencent.com/document/product/248/45121) |
| Memcached | QCE/MEMCACHED | 指标文档待上线 |
| 轻量应用服务器 Lighthouse | QCE/LIGHTHOUSE | [指标详情](https://cloud.tencent.com/document/product/248/60127) |
| TDSQL MySQL | QCE/TDMYSQL | [指标详情](https://cloud.tencent.com/document/product/248/54401) |
| 弹性公网 IP | QCE/LB | [指标详情](https://cloud.tencent.com/document/product/248/45099) |
| TDMQ RocketMQ 版 | QCE/TDMQ | [指标详情](https://cloud.tencent.com/document/product/248/51450) |
| VPN 网关 | QCE/VPNGW | [指标详情](https://cloud.tencent.com/document/product/248/45070) |
| VPN 通道 | QCE/VPNX | [指标详情](https://cloud.tencent.com/document/product/248/45071) |
| CynosDB MySQL | QCE/CYNOSDB_MYSQL | [指标详情](https://cloud.tencent.com/document/product/248/45106) |
| 云联网 | QCE/VBC | [指标详情](https://cloud.tencent.com/document/product/248/75629) |
| DTS 数据传输 | QCE/DTS | [指标详情](https://cloud.tencent.com/document/product/248/82251) |
| QAAP 全球应用加速 | QCE/QAAP | [指标详情](https://cloud.tencent.com/document/product/248/45062) |
| Web 应用防火墙 WAF | QCE/WAF | [指标详情](https://cloud.tencent.com/document/product/248/48124) |
| 文件存储 CFS | QCE/CFS | [指标详情](https://cloud.tencent.com/document/product/248/45144) |
| 分布式数据库 DCDB | QCE/DCDB | [指标详情](https://cloud.tencent.com/document/product/248/45161) |
| TSE Nacos | TSE/NACOS | [指标详情](https://cloud.tencent.com/document/product/248/88062) |
| TSE Zookeeper | TSE/ZOOKEEPER | [指标详情](https://cloud.tencent.com/document/product/248/88061) |

## 快速开始

### 方式一：从源码构建

```shell
git clone https://github.com/behappy-project/behappy-tencentcloud-exporter.git
cd behappy-tencentcloud-exporter
make build
./build/qcloud_exporter --config.file qcloud.yml
```

启动后访问 [http://127.0.0.1:9123/metrics](http://127.0.0.1:9123/metrics) 查看导出的指标。

### 方式二：Docker

使用配置文件启动：

```shell
docker run -d \
  --name tencentcloud-exporter \
  -p 9123:9123 \
  -v /path/to/qcloud.yml:/etc/tencentcloud-exporter/qcloud.yml \
  ghcr.io/behappy-project/behappy-tencentcloud-exporter \
  --config.file=/etc/tencentcloud-exporter/qcloud.yml
```

使用环境变量传入密钥：

```shell
docker run -d \
  --name tencentcloud-exporter \
  -p 9123:9123 \
  -e TENCENTCLOUD_SECRET_ID=your_secret_id \
  -e TENCENTCLOUD_SECRET_KEY=your_secret_key \
  -e TENCENTCLOUD_REGION=ap-guangzhou \
  -v /path/to/qcloud.yml:/etc/tencentcloud-exporter/qcloud.yml \
  ghcr.io/behappy-project/behappy-tencentcloud-exporter \
  --config.file=/etc/tencentcloud-exporter/qcloud.yml
```

### 方式三：Kubernetes (Helm)

```shell
# 复制并修改配置文件
cp configs/qcloud-cvm-product.yml myconfig.yml
# 编辑 myconfig.yml，填写密钥和所需产品

# 使用参数安装
helm install tencentcloud-exporter deploy/helm/tencentcloud-exporter \
  --set config.credential.accessKey=YOUR_SECRET_ID \
  --set config.credential.secretKey=YOUR_SECRET_KEY \
  --set config.credential.region=ap-guangzhou \
  --namespace monitoring --create-namespace

# 或使用 values 文件安装
helm install tencentcloud-exporter deploy/helm/tencentcloud-exporter \
  -f my-values.yaml \
  --namespace monitoring --create-namespace
```

Helm values 文件示例：

```yaml
config:
  credential:
    accessKey: "your-secret-id"
    secretKey: "your-secret-key"
    region: "ap-guangzhou"
  rateLimit: 15
  products:
    - namespace: QCE/CVM
      allMetrics: true
      allInstances: true
      extraLabels:
        - InstanceName
        - Zone

serviceMonitor:
  enabled: true
  interval: 60s
```

## 配置说明

`qcloud.yml` 完整配置参考如下。项目 `configs/` 目录下提供了各产品的配置模板。

```yaml
credential:
  access_key: <YOUR_SECRET_ID>       # 必填，云 API 的 SecretId
  secret_key: <YOUR_SECRET_KEY>      # 必填，云 API 的 SecretKey
  region: <REGION>                   # 必填，实例所在地域，如 ap-guangzhou
  role: ""                           # 可选，IAM 角色名，用于角色鉴权
  token: ""                          # 可选，临时密钥 Token

rate_limit: 15                       # 腾讯云监控 API 速率限制，官方默认上限 20 QPS

# 产品维度配置，每个产品对应一个 item
products:
  - namespace: QCE/CMONGO            # 必填，产品命名空间
    all_metrics: true                # 推荐，导出该产品支持的全部指标
    all_instances: true              # 推荐，导出该地域下的全部实例
    extra_labels:                    # 可选，将实例字段附加为指标 label
      - InstanceName
      - Zone
    only_include_metrics:            # 可选，仅导出指定指标（配置后 all_metrics 失效）
      - Inserts
    exclude_metrics:                 # 可选，排除指定指标
      - Reads
    only_include_instances:          # 可选，仅导出指定实例 ID（配置后 all_instances 失效）
      - cmgo-xxxxxxxx
    exclude_instances:               # 可选，排除指定实例 ID
      - cmgo-xxxxxxxx
    custom_query_dimensions:         # 可选，自定义查询维度，用于不支持按实例维度查询的指标
      - target: cmgo-xxxxxxxx        #   配置后 all_instances/only_include_instances/exclude_instances 失效
    statistics_types:                # 可选，对采集到的多个数据点做聚合，支持 max/min/avg/last
      - avg                          #   默认 last，取最新值
    period_seconds: 60               # 可选，指标统计周期，一般为 60 或 300 秒，默认 60
    range_seconds: 300               # 可选，采集时间范围，开始时间 = now - range_seconds
    delay_seconds: 60                # 可选，时间偏移量，结束时间 = now - delay_seconds
    metric_name_type: 1              # 可选，指标名格式化类型：1=驼峰转下划线小写，2=全部转小写；默认 2
    reload_interval_minutes: 60      # 可选，all_instances=true 时，周期刷新实例列表的间隔（分钟）

# 单个指标维度配置，每个指标对应一个 item（用于精细化控制）
metrics:
  - tc_namespace: QCE/CMONGO         # 产品命名空间
    tc_metric_name: Inserts          # 云监控定义的指标名
    tc_metric_rename: Inserts        # 导出时显示的指标名（可自定义）
    tc_metric_name_type: 1           # 可选，指标名格式化类型，同 metric_name_type，默认 1
    tc_labels:                       # 可选，附加的实例字段 label，同 extra_labels
      - InstanceName
    tc_myself_dimensions:            # 可选，自定义查询维度，同 custom_query_dimensions
    tc_statistics:                   # 可选，聚合方式，同 statistics_types
      - Avg
    period_seconds: 60               # 可选，同 period_seconds
    range_seconds: 300               # 可选，同 range_seconds
    delay_seconds: 60                # 可选，同 delay_seconds
```

### 凭证环境变量

`access_key`、`secret_key`、`region` 均可通过环境变量传入，优先级高于配置文件：

```shell
export TENCENTCLOUD_SECRET_ID="YOUR_SECRET_ID"
export TENCENTCLOUD_SECRET_KEY="YOUR_SECRET_KEY"
export TENCENTCLOUD_REGION="ap-guangzhou"
```

### 字段说明

- **custom_query_dimensions**：自定义查询维度字段，每个产品支持的维度字段可从对应的云监控指标文档查询。配置后实例过滤参数（`all_instances`、`only_include_instances`、`exclude_instances`）失效。
- **extra_labels**：将实例的属性字段附加为 Prometheus 指标的 label。可用字段取决于各产品实例查询 API 的返回结构，目前仅支持 string 和 int 类型字段。
- **period_seconds**：指标统计周期，通常支持 60 秒或 300 秒，具体可查阅对应产品的云监控文档。如不配置则默认使用 60 秒，若该指标不支持 60 秒则自动使用该指标支持的最小周期。
- **statistics_types**：对时间范围内采集到的多个数据点进行聚合计算，支持 `max`、`min`、`avg`、`last`，默认 `last` 取最新值。
- **metric_name_type**：控制导出指标名的格式化方式。`1` 表示将驼峰命名转换为下划线小写（如 `CpuUsage` -> `cpu_usage`），`2` 表示直接全部转小写。

地域可选值参考[腾讯云地域列表](https://cloud.tencent.com/document/api/248/30346#.E5.9C.B0.E5.9F.9F.E5.88.97.E8.A1.A8)。

## 命令行参数

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `--web.listen-address` | HTTP 服务监听地址和端口 | `:9123` |
| `--web.telemetry-path` | Metrics 接口路径 | `/metrics` |
| `--web.enable-exporter-metrics` | 是否导出 exporter 自身指标（`promhttp_*`、`process_*`、`go_*`） | `false` |
| `--web.max-requests` | 最大并发抓取请求数，0 表示不限制 | `0` |
| `--config.file` | 配置文件路径 | `qcloud.yml` |
| `--log.level` | 日志级别（debug/info/warn/error） | `info` |

## Prometheus 集成

在 `prometheus.yml` 中添加以下抓取配置：

```yaml
scrape_configs:
  - job_name: 'tencentcloud'
    scrape_interval: 60s
    static_configs:
      - targets: ['tencentcloud-exporter:9123']
```

建议将 `scrape_interval` 设置为 60 秒或更长，以匹配腾讯云监控 API 的数据刷新频率，避免无效请求。

Grafana 中可通过 Prometheus 数据源直接查询导出的指标，指标名格式为 `qce_<namespace>_<metric_name>`。

## 常见问题

**腾讯云监控 API 计费**

腾讯云监控已于 2022 年 09 月 01 日起对超出免费额度的 API 请求开始计费，使用前请确认已开通 API 付费并了解费用情况。

- 开通页面：https://buy.cloud.tencent.com/APIRequestBuy
- 资源消耗页：https://console.cloud.tencent.com/monitor/consumer/products
- 计费文档：https://cloud.tencent.com/document/product/248/77914

**速率限制建议**

腾讯云监控 API 官方默认限制为 20 QPS，建议将 `rate_limit` 配置在 15 左右，为其他调用预留余量。如需提升配额，可在腾讯云控制台申请。

**如何新增产品支持**

参考 `pkg/collector/` 目录下已有产品的实现方式，添加新产品的 collector 并在配置文件中注册对应的命名空间即可。欢迎通过 Pull Request 贡献新产品支持。

## License

[MIT](./LICENSE)

## 致谢

本项目 fork 自 [tencentyun/tencentcloud-exporter](https://github.com/tencentyun/tencentcloud-exporter)，在其基础上持续更新 SDK 依赖、修复问题并新增产品支持，独立维护于 [behappy-project/behappy-tencentcloud-exporter](https://github.com/behappy-project/behappy-tencentcloud-exporter)。
