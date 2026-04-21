{
  programs.btop = {
    enable = true;
    # 参考：
    # https://github.com/aristocratos/btop#configurability
    settings = {
      # --- 界面与主题 ---
      theme_background = false; # 是否显示主题背景 (建议设为 False 以实现终端透明)
      vim_keys = true; # 启用 Vim 方向键 (h,j,k,l,g,G)

      # --- 布局与显示 ---
      presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty"; # 布局预设，通过 0-9 键切换
      shown_boxes = "cpu mem net proc"; # 要显示的面板 (cpu, mem, net, proc, gpu0...)
      update_ms = 2000; # 界面刷新间隔 (毫秒)
      graph_symbol = "braille"; # 默认图表符号 (braille, block, tty)

      # --- 进程管理 ---
      proc_sorting = "cpu direct"; # 进程排序方式 (cpu direct, cpu lazy, memory, pid...)
      proc_per_core = true; # 进程 CPU 占用是基于单核还是总 CPU 占用

      # --- CPU 面板 ---
      temp_scale = "celsius"; # 温度单位 (celsius, fahrenheit, kelvin, rankine)
      show_cpu_freq = true; # 是否显示 CPU 当前频率

      # --- 内存面板 ---
      mem_graphs = true; # 内存值是否显示为图表而非进度条
      zfs_arc_cached = true; # 是否将 ZFS ARC 计入已缓存和可用内存
      show_swap = true; # 是否显示交换内存 (Swap)
      swap_disk = true; # 是否将交换内存显示为磁盘条目
      show_disks = false; # 是否在内存面板中拆分显示磁盘信息
      only_physical = true; # 仅显示物理磁盘，过滤掉网络/虚拟磁盘
      use_fstab = true; # 是否从 /etc/fstab 读取磁盘列表
      zfs_hide_datasets = false; # 隐藏所有 ZFS 数据集，仅显示 ZFS 池
      disk_free_priv = false; # 是否为特权用户显示额外可用磁盘空间

      # --- 磁盘 IO ---
      show_io_stat = true; # 是否显示磁盘 IO 活动百分比 (busy time)
      io_mode = false; # 是否启用磁盘 IO 模式 (显示读写大图表)
      io_graph_combined = false; # IO 模式下是否显示读写合并图表
      io_graph_speeds = ""; # 手动设置特定挂载点的最高 IO 速度 (例如 "/:100 /home:50")

      # --- 网络面板 ---
      net_download = 100; # 手动设置下载带宽上限 (仅在 net_auto 为 False 时有效)
      net_upload = 100; # 手动设置上传带宽上限 (仅在 net_auto 为 False 时有效)
      net_auto = true; # 网络图表是否自动缩放比例
      net_sync = true; # 下载和上传图表是否同步缩放比例
      net_iface = ""; # 默认选中的网络接口 (留空则自动检测)

      # --- 其它设置 ---
      base_10_sizes = false; # 是否使用 10 进制单位 (KB=1000) 而非二进制单位 (KiB=1024)
      base_10_bitrate = "Auto"; # 网络比特率是否使用 10 进制 (Kbps)
      clock_format = "%X"; # 时钟显示格式 (strftime 格式)
      background_update = true; # 打开菜单时是否在后台继续更新 UI
      show_battery = true; # 是否显示电池电量 (如果存在)
      selected_battery = "Auto"; # 选择要显示的电池
      show_battery_watts = true; # 是否显示电池充放电功率
      log_level = "WARNING"; # 日志记录级别 (ERROR, WARNING, INFO, DEBUG)
      save_config_on_exit = true; # 退出时是否自动保存当前在 UI 中更改的设置
    };
  };
}
