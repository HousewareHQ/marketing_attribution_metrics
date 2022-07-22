with segment_tracks as (
    select *
    from {{ var('segment_tracks') }}
),
segment_identifies as (
    select *
    from {{ var('segment_identifies') }}
),
hubspot_email_event as (
    select *
    from {{ var('hubspot_email_event') }}
),
hubspot_email_campaign as (
    select *
    from {{ var('hubspot_email_campaign') }}
)

select
    segment_tracks.anonymous_id as segment_anonymous_id,
    segment_tracks.context_page_url as segment_context_page_url,
    segment_tracks.timestamp as segment_timestamp,
    segment_identifies.email as segment_email,
    segment_tracks.event as segment_event,
    hubspot_email_event.created_timestamp as hubspot_created_timestamp,
    hubspot_email_event.event_id as hubspot_event_id,
    hubspot_email_event.event_type as hubspot_event_type,
    concat(
        hubspot_email_campaign.email_campaign_id,
        ': ',
        hubspot_email_campaign.email_campaign_name
    ) as hubspot_email_campaign
from
    hubspot_email_event
    join hubspot_email_campaign
        on hubspot_email_campaign.email_campaign_id = hubspot_email_event.email_campaign_id
    join segment_identifies
        on segment_identifies.email = hubspot_email_event.recipient_email_address
    join segment_tracks
        on segment_identifies.anonymous_id = segment_tracks.anonymous_id

where
    hubspot_email_event.event_type in {{ var('hubspot_email_event_filter__in') }}
    and segment_tracks.timestamp > hubspot_email_event.created_timestamp
