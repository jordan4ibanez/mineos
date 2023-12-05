default:
	@echo Transpiling mineos...
	@npx tstl
	@echo Successfully built mineos

windows: 
	@echo Transpiling mineos...
	@npx tstl
	@echo Successfully built mineos
	@echo Starting Minetest.
	@../../bin/minetest.exe

linux:
	@echo Transpiling mineos...
	@npx tstl
	@echo Successfully built mineos
	@echo Starting Minetest.
	@minetest
