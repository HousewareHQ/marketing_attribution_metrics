-- depends_on: {{ ref('segment_tracks_hubspot_email_events_enriched') }}

select *
from {{ metrics.metric(
    metric_name='weekly_email_to_product_events',
    grain='week',
    dimensions=[],
    secondary_calculations=[]
)}}
