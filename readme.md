YAML file format:

Evaluation group:

unique_key: [Object]
    group_name: [String]
    interval_seconds: [Number]
    rules: [Object]

Alert rules:
unique_key: [Object]
    rule_name: [String]*
    rule_summary: [String]*
    query_type: [String]
    filters: [String]
    cross_series_reducer: [String]
    aggregations: [Object]
        allignment_period: [String]
        per_series_aligner: [String]
        group_by_fields: [Array]
    pre_processor: [String]
    project_name: [String]
    reducer_type: [String]
    threshold_type: [String]
    threshold_value: [Number]
    contact_point: [String]
