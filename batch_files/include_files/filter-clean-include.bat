@echo off
IF EXIST Y:\ (
	cd Y:\share\filter\qa5_include_file_dirs
	del Y:\share\filter\qa5_include_file_dirs\* /s /q
	for /d %%x in (Y:\share\filter\qa5_include_file_dirs\*) do rmdir %%x /s /q
) ELSE (
	echo Drive not mapped...
	echo Invalid Test.
)
