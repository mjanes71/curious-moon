DB=enceladus
BUILD=${CURDIR}/build.sql
SCRIPTS=${CURDIR}/scripts
CSV='${CURDIR}/data/master_plan.CSV'
MASTER=$(SCRIPTS)/import.sql
NORMALIZE=$(SCRIPTS)/normalize.sql
#all is a target, what is indented beneath is a recipe
#all is the default target, if you don't specify a target when executing make command
all: normalize 
	psql $(DB) -f $(BUILD) 
master:
	@cat $(MASTER) >> $(BUILD)
#import can't be built without master
import: master
	@echo "COPY import.master_plan FROM $(CSV) WITH DELIMITER ',' HEADER CSV;" << $(BUILD)
#normalize can't be built without import
normalize: import
	@cat $(NORMALIZE) >> $(BUILD)
#tears down the build
clean:
	@rm -rf $(BUILD)
