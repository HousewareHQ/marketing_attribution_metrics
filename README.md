# Marketing Attribution Metrics dbt Package ([Docs](https://housewarehq.github.io/marketing_attribution_metrics))

# 📣 What does this dbt package do?
This package provides cross-functional metrics by combining Hubspot data from [Fivetran's Hubspot connector](https://fivetran.com/docs/applications/hubspot) and Segment data from [Fivetran's Segment connector](https://fivetran.com/docs/applications/segment). It uses data in the format described by [Hubspot ERD](https://fivetran.com/docs/applications/hubspot#schemainformation) and [Segment ERD](https://fivetran.com/docs/applications/segment#schemainformation).

This package enables you to attribute marketing campaigns to product events. The scope of this package is not just limited to product events, it can be transactions/subscriptions on Stripe and other activities tracked by SaaS tools.

## Metrics 

This package contains transformed models built on top of [Houseware's Hubspot package](https://github.com/HousewareHQ/dbt_hubspot_metrics) and [Houseware's Segment package](https://github.com/HousewareHQ/dbt_segment_metrics). Dependencies on these packages have been declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The metrics offered by this package are described below

| **metric**                          | **description**                                                                                                                                                                                                                              |
|--------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| weekly_email_to_product_events    | Weekly Email to Product Events.                
|                        

# 🎯 How do I use the dbt package?
## Step 1: Prerequisites
To use this dbt package, you must have the following:
- At least one Fivetran hubspot connector and one Fivetran segment connector syncing data into your destination. 
- A **BigQuery**, **Snowflake**, **Redshift**, or **PostgreSQL** destination.


## Step 2: Install the package

Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yaml
packages:
  - git: "https://github.com/HousewareHQ/marketing_attribution_metrics.git"
    revision: v0.1.0
```

## Step 3: Define database and schema variables

By default, this package will look for your Hubspot data in the `fivetran_hubspot` schema and Segment data in the `fivetran_segment` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your data is, please add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
  hubspot_source:
    hubspot_schema: my_new_schema_name
  
  segment_metrics:
    segment__schema: my_new_schema_name
```

For additional configurations for the Hubspot source models, please visit the [Hubspot source package](https://github.com/fivetran/dbt_hubspot_source).

## (Optional) Step 4: Change build schema
By default this package will build the Hubspot staging models within a schema titled (<target_schema> + `_stg_hubspot`) and the Hubspot metrics as well as Segment metrics within <target_schema> in your target database. If this is not where you would like your modeled Hubspot data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
models:
  hubspot_metrics:
    +schema: my_new_schema_name # leave blank for just the target_schema
  hubspot_source:
    +schema: my_new_schema_name # leave blank for just the target_schema
  segment_metrics:
    +schema: my_new_schema_name # leave blank for just the target_schema
```


# 🗄 Which warehouses are supported?
This package has been tested on Snowflake.


# 🙌 Can I contribute?

Additional contributions to this package are very welcome! Please create issues
or open PRs against `main`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.


# 🏪 Are there any resources available?
- Provide [feedback](https://airtable.com/shrPHxTmfkjq3P6Eh) on what you'd like to see next
- Have questions, feedback, or need help? Email us at nipun@houseware.io
- Check out [Houseware's blog](https://www.houseware.io/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices