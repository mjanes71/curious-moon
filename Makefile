DB=enceladus
BUILD=${CURDIR}/build.sql
SCRIPTS=${CURDIR}/scripts
CSV='${CURDIR}/data/master_plan.csv'
MASTER=$(SCRIPTS)/import.sql
NORMALIZE=$(SCRIPTS)/normalize.sql
#all is a target, what is indented beneath is a recipe
#all is the default target, if you don't specify a target when executing make command

all: normalize #execute the build file against the db
	psql $(DB) -f $(BUILD) 
master: #add the import sql file to the build file
	@cat $(MASTER) >> $(BUILD)
#import can't be built without master
import: master #add the copy data statment to the build file
	@echo "COPY import.master_plan FROM $(CSV) WITH DELIMITER ',' HEADER CSV;" >> $(BUILD)
#normalize can't be built without import
normalize: import #add the normalize sql file to the build file
	@cat $(NORMALIZE) >> $(BUILD)
#tears down the build
clean:
	@rm -rf $(BUILD)
