-- 为了方便在不同机器上个性化选择所需语言，避免 mason 安装过多工具，
-- 改为用 gitignore 的文件 land-select.lua 来 import 对应的语言，
-- 请在当前目录自行创建 land-select.lua 文件，并选配所需语言
-- 示例：
-- return {
--   { import = "plugins/extras/lang/python" },
--   { import = "plugins/extras/lang/markdown" },
--   { import = "plugins/extras/lang/typescipt" },
-- }
-- 或者直接导入所有语言的配置：
-- return {
--   { import = "plugins/extras/lang"}
-- }

return {
  { import = "plugins/extras/lang"}
}
