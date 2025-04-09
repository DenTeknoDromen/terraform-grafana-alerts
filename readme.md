>This is a terraform module intended as a prototype for creating alerts in Grafana with Terraform, 
>it reads input from "input.yaml" and configures the alerts inside the specified alert rules.

 ### Keys
>To use the module, create a terraform file called "auth.tf" and add a variable called  
>"auth_token_grafana".

 ### YAML file format:

> #### Evaluation group:
>
> - unique_key: [Object]*
>   - group_name: [String]*
>   - interval_seconds: [Number]*
>   - rules: [Object]*
>
> #### Alert rules:
>
> - unique_key: [Object]*
>   - rule_name: [String]*
>   - rule_summary: [String]*
>   - query_type: [String]
>   - filters: [String]
>   - cross_series_reducer: [String]
>   - aggregations: [Object]
>     - allignment_period: [String]
>     - per_series_aligner: [String]
>     - group_by_fields: [Array]
>   - pre_processor: [String]
>   - project_name: [String]
>   - reducer_type: [String]
>   - threshold_type: [String]
>   - threshold_value: [Number]
>   - no_data_state: [String]
>   - pending_period: [String]
>   - contact_point: [String]
>
>* = required

 ### Filters
>Grafana reads metric filters as a list with every label separated with an " AND ".  
>The rule block in main.tf contains a regex code which should string input to the correct format  
>  
>Correct input should look like this:  
>"resource.label.service_name=a-service-name AND metric.type=run.googleapis.com/request_count"  
>  
>which becomes:  
>[  
>resource.label.service_name,  
>=,  
>a-service-name,  
>AND,  
>metric.type,  
>=,  
>run.googleapis.com/request_count,  
>]

 ### UIDs
>Terraform can access resources (data sources, contact points, alerts rules) created with the Grafana GUI if UID is provided,  
>UID can be found in the GUI after exporting the relevant resource