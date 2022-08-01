with segment_tracks as (
    select *
    from {{ var('segment_tracks') }}
),
segment_identifies as (
    select distinct email, anonymous_id
    from {{ var('segment_identifies') }}
),
segment_tracks__joined_identifies as (
    select segment_tracks.*, segment_identifies.email from segment_tracks
    left join segment_identifies
        on segment_identifies.anonymous_id = segment_tracks.anonymous_id
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
    hubspot_email_event.created_timestamp as hubspot_created_timestamp,
    hubspot_email_event.event_id as hubspot_event_id,
    hubspot_email_event.event_type as hubspot_event_type,
    concat(
        hubspot_email_campaign.email_campaign_id,
        ': ',
        hubspot_email_campaign.email_campaign_name
    ) as hubspot_email_campaign,
    hubspot_email_event.recipient_email_address as hubspot_email,
    segment_tracks__joined_identifies.message_id as segment_message_id,
    segment_tracks__joined_identifies.anonymous_id as segment_anonymous_id,
    segment_tracks__joined_identifies.context_page_url as segment_context_page_url,
    segment_tracks__joined_identifies.timestamp as segment_timestamp,
    segment_tracks__joined_identifies.email as segment_email,
    segment_tracks__joined_identifies.event as segment_event
from
    hubspot_email_event
    left join hubspot_email_campaign
        on hubspot_email_campaign.email_campaign_id = hubspot_email_event.email_campaign_id
    left join segment_tracks__joined_identifies
        on segment_tracks__joined_identifies.email = hubspot_email_event.recipient_email_address
        and {{ dbt_utils.datediff('hubspot_email_event.created_timestamp', 'segment_tracks__joined_identifies.timestamp', var('hubspot_event_to_segment_event_time_interval')) }}
            <= {{ var('hubspot_event_to_segment_event_time_value') }}
        and {{ dbt_utils.datediff('hubspot_email_event.created_timestamp', 'segment_tracks__joined_identifies.timestamp', var('hubspot_event_to_segment_event_time_interval')) }}
            > 0

where
    hubspot_email_event.event_type in {{ var('hubspot_email_event_filter__in') }}
