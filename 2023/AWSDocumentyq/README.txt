This version downloads the yq binary from S3 and sets the appropriate permissions, then it downloads a file called commands.txt from S3 to the temporary directory, and executes the commands in that file using the xargs command. The xargs command reads the commands from the file and executes them one by one.

You will need to replace <S3_BUCKET_NAME> with the name of your S3 bucket, and make sure that the commands.txt file exists in the bucket and contains the commands you want to execute.

yq w -i /etc/otel/collector/agent_config.yaml receivers.prometheus/configs '[{"job_name": "oracle-short","metrics_path": "/metrics","static_configs": [{"targets": ["oracle.host.com:9161"]}], "relabel_configs": [{"source_labels": ["__address__"],"target_label": "instance","regex": "(.*):\\d+","replacement": "${1}"}]},{"job_name": "oracle-tab","scrape_interval": "6h","scrape_timeout": "120s","metrics_path": "/metrics","params": {"tablerows": ["true"],"lobbytes": ["true"],"recovery": ["true"]},"static_configs": [{"targets": ["oracle.host.com:9161"]}], "relabel_configs": [{"source_labels": ["__address__"],"target_label": "instance","regex": "(.*):\\d+","replacement": "${1}"}]},{"job_name": "oracle-ind","scrape_interval": "6h","scrape_timeout": "120s","metrics_path": "/metrics","params": {"tablebytes": ["true"],"indexbytes": ["true"],"recovery": ["true"]},"static_configs": [{"targets": ["oracle.host.com:9161"]}], "relabel_configs": [{"source_labels": ["__address__"],"target_label": "instance","regex": "(.*):\\d+","replacement": "${1}"}]}]'

checks if configs section exists

yq eval --inplace '(.receivers."prometheus/oracle".config) |= {"scrape_configs": [{ "job_name": "oracle-short", "metrics_path": "/metrics", "static_configs": [{ "targets": ["oracle.host.com:9161"] }], "relabel_configs": [{ "source_labels": ["__address__"], "target_label": "instance", "regex": "(.*):\\d+", "replacement": "${1}" }] }, { "job_name": "oracle-tab", "scrape_interval": "6h", "scrape_timeout": "120s", "metrics_path": "/metrics", "params": { "tablerows": [true], "lobbytes": [true], "recovery": [true] }, "static_configs": [{ "targets": ["oracle.host.com:9161"] }], "relabel_configs": [{ "source_labels": ["__address__"], "target_label": "instance", "regex": "(.*):\\d+", "replacement": "${1}" }] }, { "job_name": "oracle-ind", "scrape_interval": "6h", "scrape_timeout": "120s", "metrics_path": "/metrics", "params": { "tablebytes": [true], "indexbytes": [true], "recovery": [true] }, "static_configs": [{ "targets": ["oracle.host.com:9161"] }], "relabel_configs": [{ "source_labels": ["__address__"], "target_label": "instance", "regex": "(.*):\\d+", "replacement": "${1}" }] }]}' agent_config.yaml

----------------------------------------------------------------------
Read YAML value from file: yq r <filename> <key>

This command will read the value associated with the key specified in the YAML file. For example:

yq r sample.yaml connections[0].instance

This will return the value of instance key for the first connections item in sample.yaml.

Write YAML value to file: yq w -i <filename> <key> <value>

This command will write the value to the specified key in the YAML file. For example:

yq w -i sample.yaml connections[1].database "PROD"

This will set the value of database key to PROD for the second connections item in sample.yaml.

Update YAML value in file: yq w -i <filename> <key> <value>

This command will update the value of the specified key in the YAML file. For example:

yq w -i sample.yaml connections[2].instance "TEST"

This will update the value of instance key to TEST for the third connections item in sample.yaml.

Delete YAML value from file: yq d -i <filename> <key>

This command will delete the specified key and its value from the YAML file. For example:

yq d -i sample.yaml connections[1].database

This will delete the database key and its value from the second connections item in sample.yaml.

Combine multiple YAML files: yq merge <file1> <file2> ...

This command will combine multiple YAML files into a single file. For example:

yq merge file1.yaml file2.yaml > combined.yaml

This will merge file1.yaml and file2.yaml into a single YAML file called combined.yaml.

Filter YAML using expressions: yq eval '<expression>' <filename>

This command will filter the YAML data using the specified expressions. For example:

yq eval '.connections[].instance' sample.yaml

This will return the value of instance key for all the connections items in sample.yaml.

Read YAML value from JSON input: yq r -j <filename> <key>

This command will read the value associated with the key specified in the JSON file. For example:

yq r -j sample.json connections[0].instance

This will return the value of instance key for the first connections item in sample.json.

