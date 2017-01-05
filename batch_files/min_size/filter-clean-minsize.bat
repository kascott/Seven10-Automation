@echo off
IF EXIST Y:\ (
	cd Y:\share\filter\qa5_min_file_size
	del Y:\share\filter\qa5_min_file_size\* /s /q
	for /d %%x in (Y:\share\filter\qa5_min_file_size\*) do rmdir %%x /s /q
) ELSE (
	echo Drive not mapped...
	echo Invalid Test.
)
