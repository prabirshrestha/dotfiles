local scoop_dir = os.getenv('SCOOP')
if not scoop_dir then
	scoop_dir = os.getenv('USERPROFILE')..'/scoop'
end
local scoop_global = os.getenv('SCOOP_GLOBAL')


local function trim_extensions (apps)
	for k, v in pairs(apps) do
		apps[k] = string.match(v, '[%w-]*')
	end
	return apps
end

local function find_dirs (path)
	dirs = clink.find_dirs(path)
	-- Remove .. and . from table of directories
	table.remove(dirs, 1)
	table.remove(dirs, 1)
	return dirs
end

local function find_files (path)
	files = clink.find_files(path)
	-- Remove .. and . from table of files
	table.remove(files, 1)
	table.remove(files, 1)
	return files
end

local function get_cache ()
	cache = find_files(scoop_dir..'/cache/*')
	for i, name in pairs(cache) do
		signPos = string.find(name, "#")
		cache[i] = signPos and string.sub(name, 0, signPos - 1) or nil
	end
	return cache
end

local Buckets = {}

function Buckets.get_local ()
	return find_dirs(scoop_dir..'/buckets/*')
end

function Buckets.get_known ()
	json = io.open(scoop_dir..'/apps/scoop/current/buckets.json')
	known = {}
	for line in json:lines() do
		bucket = string.match(line, '\"(.-)\"')
		if bucket then
			table.insert(known, bucket)
		end
	end
	return known
end

local Apps = {}

function Apps.get_installed ()
	installed = find_dirs(scoop_dir..'/apps/*')
	if scoop_global then
		for _, dir in pairs(find_dirs(scoop_global..'/apps/*')) do
			table.insert(installed, dir)
		end
	end
	return installed
end

function Apps.get_known ()
	apps = trim_extensions(clink.find_files(scoop_dir..'/apps/scoop/current/bucket/*.json'))
	for _, dir in pairs(Buckets.get_local()) do
		for u, app in pairs(trim_extensions(clink.find_files(scoop_dir..'/buckets/'..dir..'/*.json'))) do
			table.insert(apps, app)
		end
		for u, app in pairs(trim_extensions(clink.find_files(scoop_dir..'/buckets/'..dir..'/bucket/*.json'))) do
			table.insert(apps, app)
		end
	end
	return apps
end

local parser = clink.arg.new_parser

local boolean_parser = parser({'true', 'false'})
local architecture_parser = parser({'32bit', '64bit'})

local config_parser = parser({
	'MSIEXTRACT_USE_LESSMSI' ..boolean_parser,
	'aria2-enabled' ..boolean_parser,
	'aria2-retry-wait',
	'aria2-split',
	'aria2-max-connection-per-server',
	'aria2-min-split-size',
	'aria2-options',
	'NO_JUNCTIONS' ..boolean_parser,
	'show_update_log' ..boolean_parser,
	'virustotal_api_key',
	'proxy'
})

local scoop_parser = parser({
	{'info', 'depends', 'home'} ..parser({Apps.get_known}),
	'alias' ..parser({'add', 'list' ..parser({'-v', '--verbose'}), 'rm'}),
	'bucket' ..parser({'add' ..parser({Buckets.get_known}), 'list', 'known', 'rm' ..parser({Buckets.get_local})}),
	'cache' ..parser({'show', 'rm'} ..parser({get_cache})),
	'checkup',
	'cleanup' ..parser({Apps.get_installed},
		'-g', '--global'):loop(1),
	'config' ..config_parser,
	'create',
	'export',
	'list',
	'install' ..parser({Apps.get_known},
		'-g', '--global',
		'-i', '--independent',
		'-k', '--no-cache',
		'-s', '--skip',
		'-a' ..architecture_parser, '--arch' ..architecture_parser
		):loop(1),
	'prefix' ..parser({Apps.get_installed}),
	'reset' ..parser({Apps.get_installed}):loop(1),
	'search',
	'status',
	'uninstall' ..parser({Apps.get_installed},
		'-g', '--global',
		'-p', '--purge'):loop(1),
	'update' ..parser({Apps.get_installed},
		'-g', '--global',
		'-f', '--force',
		'-i', '--independent',
		'-k', '--no-cache',
		'-s', '--skip',
		'-q', '--quite'):loop(1),
	'virustotal' ..parser({Apps.get_known},
		'-a' ..architecture_parser, '--arch' ..architecture_parser,
		'-s', '--scan',
		'-n', '--no-depends'):loop(1),
	'which'
})

local help_parser = parser({
	'help' ..parser(scoop_parser:flatten_argument(1))
})

clink.arg.register_parser('scoop', scoop_parser)
clink.arg.register_parser('scoop', help_parser)
