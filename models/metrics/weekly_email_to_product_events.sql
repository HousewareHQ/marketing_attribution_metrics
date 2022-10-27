-- depends_on: {{ ref('segment_tracks_hubspot_email_events_enriched') }}

select *
from {{ metrics.calculate(
    metric('weekly_email_to_product_events'),
    grain='week',
    dimensions=['hubspot_event_type', 'segment_event'],
    secondary_calculations=[]
)}}
