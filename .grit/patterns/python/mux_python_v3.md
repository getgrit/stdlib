---
title: Upgrade to Mux v3
tags: [mux, stainless, sdk]
annotations:
  grit.io/autogen/source: https://github.com/muxinc/mux-python/tree/3.15.0
  grit.io/autogen/destination: https://github.com/stainless-sdks/mux-python/commit/f04ab06d6927f4435369cc32e66f7ff6672702c1
---

The Mux Python SDK has been rewritten for v3 and contains significant changes.

An automated migration is available using the [Grit CLI](https://docs.grit.io/cli/quickstart):

```
grit apply mux_python_v3
```

```grit
language python

pattern mux_v3_config() {
	`$mp.Configuration($_)` as $config where {
		$args = [],
		$program <: maybe contains bubble($config, $args) binding_access(binding=$config) as $one_case where {
			$one_case <: within or {
				`$one_case.username = $username` => . where $args += `token_id=$username`,
				`$one_case.password = $password` => . where $args += `token_secret=$password`
			}
		},
		$joined_args = join($args, ", ")
	} => `$mp.Mux($joined_args)`
}

pattern mux_v3_api_client() {
	mux_api_constructor($args) as $constructor where {
		$client = `client`,
		$args <: maybe contains `mux_python.ApiClient($config)` where {
			$client = $config
		},
		$program <: contains bubble($constructor, $client) binding_access(binding=$constructor) as $access where {
			$access <: or {
				within `$access = $_` => . ,
				$access => `$client` where {
					$access <: maybe within mux_v3_api_remaps()
				}
			}
		}
	}
}

pattern mux_api_constructor($args) {
	or {
		`$mp.AssetsApi($args)`,
		`$mp.DeliveryUsageApi($args)`,
		`$mp.LiveStreamsApi($args)`,
		`$mp.PlaybackIdApi($args)`,
		`$mp.PlaybackRestrictionsApi($args)`,
		`$mp.SpacesApi($args)`,
		`$mp.TranscriptionVocabulariesApi($args)`,
		`$mp.WebInputsApi($args)`,
		`$mp.DimensionsApi($args)`,
		`$mp.MonitoringApi($args)`,
		`$mp.MetricsApi($args)`,
		`$mp.ErrorsApi($args)`,
		`$mp.FiltersApi($args)`,
		`$mp.IncidentsApi($args)`,
		`$mp.RealTimeApi($args)`
	}
}

pattern mux_v3_api_remaps() {
	or {
		// Video
		`$api.list_assets($args)` => `$api.video.assets.list($args)`,
		`$api.create_asset($args)` => `$api.video.assets.create($args)`,
		`$api.get_asset($args)` => `$api.video.assets.retrieve($args)`,
		`$api.update_asset($args)` => `$api.video.assets.update($args)`,
		`$api.delete_asset($args)` => `$api.video.assets.delete($args)`,
		`$api.create_asset_playback_id($args)` => `$api.video.assets.create_playback_id($args)`,
		`$api.create_asset_track($args)` => `$api.video.assets.create_track($args)`,
		`$api.delete_asset_playback_id($args)` => `$api.video.assets.delete_playback_id($args)`,
		`$api.delete_asset_track($args)` => `$api.video.assets.delete_track($args)`,
		`$api.generate_asset_track_subtitles($args)` => `$api.video.assets.generate_subtitles($args)`,
		`$api.get_asset_input_info($args)` => `$api.video.assets.retrieve_input_info($args)`,
		`$api.get_asset_playback_id($args)` => `$api.video.assets.retrieve_playback_id($args)`,
		`$api.update_asset_master_access($args)` => `$api.video.assets.update_master_access($args)`,
		`$api.update_asset_mp4_support($args)` => `$api.video.assets.update_mp4_support($args)`,
		// Delivery
		`$api.list_delivery_usage($args)` => `$api.video.delivery_usage.list($args)`,
		// Live streams
		`$api.create_live_stream($args)` => `$api.video.live_streams.create($args)`,
		`$api.get_live_stream($args)` => `$api.video.live_streams.retrieve($args)`,
		`$api.update_live_stream($args)` => `$api.video.live_streams.update($args)`,
		`$api.list_live_streams($args)` => `$api.video.live_streams.list($args)`,
		`$api.delete_live_stream($args)` => `$api.video.live_streams.delete($args)`,
		`$api.signal_live_stream_complete($args)` => `$api.video.live_streams.complete($args)`,
		`$api.create_live_stream_playback_id($args)` => `$api.video.live_streams.create_playback_id($args)`,
		`$api.create_live_stream_simulcast_target($args)` => `$api.video.live_streams.create_simulcast_target($args)`,
		`$api.delete_live_stream_playback_id($args)` => `$api.video.live_streams.delete_playback_id($args)`,
		`$api.delete_live_stream_simulcast_target($args)` => `$api.video.live_streams.delete_simulcast_target($args)`,
		`$api.disable_live_stream($args)` => `$api.video.live_streams.disable($args)`,
		`$api.enable_live_stream($args)` => `$api.video.live_streams.enable($args)`,
		`$api.reset_stream_key($args)` => `$api.video.live_streams.reset_stream_key($args)`,
		`$api.get_live_stream_playback_id($args)` => `$api.video.live_streams.retrieve_playback_id($args)`,
		`$api.get_live_stream_simulcast_target($args)` => `$api.video.live_streams.retrieve_simulcast_target($args)`,
		`$api.update_live_stream_embedded_subtitles($args)` => `$api.video.live_streams.update_embedded_subtitles($args)`,
		`$api.update_live_stream_generated_subtitles($args)` => `$api.video.live_streams.update_generated_subtitles($args)`,
		// Playback ID
		`$api.get_playback_id($args)` => `$api.video.playback_ids.retrieve($args)`,
		// PlaybackRestrictions
		`$api.create_playback_restriction($args)` => `$api.video.playback_restrictions.create($args)`,
		`$api.get_playback_restriction($args)` => `$api.video.playback_restrictions.retrieve($args)`,
		`$api.list_playback_restrictions($args)` => `$api.video.playback_restrictions.list($args)`,
		`$api.delete_playback_restriction($args)` => `$api.video.playback_restrictions.delete($args)`,
		`$api.update_referrer_domain_restriction($args)` => `$api.video.playback_restrictions.update_referrer($args)`,
		// Spaces
		`$api.create_space($args)` => `$api.video.space.create($args)`,
		`$api.get_space($args)` => `$api.video.space.retrieve($args)`,
		`$api.list_spaces($args)` => `$api.video.space.list($args)`,
		`$api.delete_space($args)` => `$api.video.space.delete($args)`,
		`$api.create_space_broadcast($args)` => `$api.video.space.create_broadcast($args)`,
		`$api.delete_space_broadcast($args)` => `$api.video.space.delete_broadcast($args)`,
		`$api.retrieve_space_broadcast($args)` => `$api.video.space.retrieve_broadcast($args)`,
		`$api.start_space_broadcast($args)` => `$api.video.space.start_broadcast($args)`,
		`$api.stop_space_broadcast($args)` => `$api.video.space.stop_broadcast($args)`,
		// TranscriptionVocabularies
		`$api.create_transcription_vocabulary($args)` => `$api.video.transcription_vocabularies.create($args)`,
		`$api.get_transcription_vocabulary($args)` => `$api.video.transcription_vocabularies.retrieve($args)`,
		`$api.update_transcription_vocabulary($args)` => `$api.video.transcription_vocabularies.update($args)`,
		`$api.list_transcription_vocabularies($args)` => `$api.video.transcription_vocabularies.list($args)`,
		`$api.delete_transcription_vocabulary($args)` => `$api.video.transcription_vocabularies.delete($args)`,
		// WebInputs
		`$api.create_web_input($args)` => `$api.web_inputs.assets.create($args)`,
		`$api.get_web_input($args)` => `$api.web_inputs.assets.retrieve($args)`,
		`$api.list_web_inputs($args)` => `$api.web_inputs.assets.list($args)`,
		`$api.delete_web_input($args)` => `$api.web_inputs.assets.delete($args)`,
		`$api.launch_web_input($args)` => `$api.web_inputs.assets.launch($args)`,
		`$api.reload_web_input($args)` => `$api.web_inputs.assets.reload($args)`,
		`$api.shutdown_web_input($args)` => `$api.web_inputs.assets.shutdown($args)`,
		`$api.update_web_input_url($args)` => `$api.web_inputs.assets.update_url($args)`,
		// Dimensions
		`$api.list_dimensions($args)` => `$api.data.dimensions.list($args)`,
		`$api.list_dimension_values($args)` => `$api.data.dimensions.list_values($args)`,
		// Monitoring
		`$api.list_monitoring_dimensions($args)` => `$api.data.monitoring.list_dimensions($args)`,
		// Metrics
		`$api.list_all_metric_values($args)` => `$api.data.monitoring.metrics.list($args)`,
		`$api.list_breakdown_values($args)` => `$api.data.monitoring.metrics.get_breakdown($args)`,
		`$api.get_metric_timeseries_data($args)` => `$api.data.monitoring.metrics.get_breakdown_timeseries($args)`,
		`$api.get_metric_values($args)` => `$api.data.monitoring.metrics.get_breakdown_values($args)`,
		`$api.get_metric_timeseries_data($args)` => `$api.data.monitoring.metrics.get_timeseries($args)`,
		// Errors
		`$api.list_errors($args)` => `$api.data.errors.list($args)`,
		// Filters
		`$api.list_values($args)` => `$api.data.filters.list_values($args)`,
		// Incidents
		`$api.list_incidents($args)` => `$api.data.incidents.list($args)`,
		`$api.get_incident($args)` => `$api.data.incidents.retrieve($args)`,
		`$api.list_related_incidents($args)` => `$api.data.incidents.list_related($args)`,
		// RealTime
		`$api.get_realtime_breakdown($args)` => `$api.data.real_time.retrieve_breakdown($args)`,
		`$api.list_realtime_dimensions($args)` => `$api.data.real_time.list_dimensions($args)`,
		`$api.list_realtime_metrics($args)` => `$api.data.real_time.list_metrics($args)`,
		`$api.get_realtime_histogram_timeseries($args)` => `$api.data.real_time.retrieve_histogram_timeseries($args)`,
		`$api.get_realtime_timeseries($args)` => `$api.data.real_time.retrieve_timeseries($args)`
	}
}

file($body) where {
	$body <: contains or {
		mux_v3_config(),
		mux_v3_api_client()
	}
}
```

Alternatively, review this migration guide and apply the changes manually.

## Configuration and authentication

Previously, you needed to create a `Configuration` object and set the `username` and `password` fields.

```python
import mux_python

configuration = mux_python.Configuration()
configuration.username = os.environ['MUX_TOKEN_ID']
configuration.password = os.environ['MUX_TOKEN_SECRET']
```

Now, you create a `Mux` client object and pass in the `token_id` and `token_secret` as arguments.

```python
import mux_python

configuration = mux_python.Mux(
    token_id=os.environ['MUX_TOKEN_ID'],
    token_secret=os.environ['MUX_TOKEN_SECRET']
)
```

## API client

Previously, you would create an API client object and pass it into specific API constructors.

```python
import mux_python

# Create and configure API client
configuration = mux_python.Configuration()
assets_api = mux_python.AssetsApi(mux_python.ApiClient(configuration))

# List Assets
list_assets_response = assets_api.list_assets()
```

Now, APIs can be directly called on the `Mux` client object.

```python
import mux_python

# Create and configure API client
configuration = mux_python.Mux()

# List Assets
list_assets_response = configuration.video.assets.list()
```

## API Method Changes

Many API methods have been renamed and restructured.

- Parameters are now passed as keyword arguments instead of in a request object.
- Required path parameters like `asset_id` are passed as positional arguments
- Return types are now the resource objects directly instead of response wrappers

### Assets API

Methods are now accessed through `video.assets` instead of an `AssetsApi` class

Method names have been simplified and standardized:

- `create_asset()` -> `create()`
- `get_asset()` -> `retrieve()`
- `update_asset()` -> `update()`
- `list_assets()` -> `list()`
- `delete_asset()` -> `delete()`
- `create_asset_playback_id()` -> `create_playback_id()`
- `create_asset_track()` -> `create_track()`
- `delete_asset_playback_id()` -> `delete_playback_id()`
- `delete_asset_track()` -> `delete_track()`
- `generate_asset_track_subtitles()` -> `generate_subtitles()`
- `get_asset_input_info()` -> `retrieve_input_info()`
- `get_asset_playback_id()` -> `retrieve_playback_id()`
- `update_asset_master_access()` -> `update_master_access()`
- `update_asset_mp4_support()` -> `update_mp4_support()`

Old example:

```python
import mux_python
client = mux_python.Configuration()
assets_api = mux_python.AssetsApi(mux_python.ApiClient(client))

# Asset API methods
asset = assets_api.create_asset(request)
asset = assets_api.get_asset(asset_id)
assets_page = assets_api.list_assets()
playback_id = assets_api.create_asset_playback_id(asset_id, params)
```

New example:

```python
import mux_python
client = mux_python.Mux()

# Asset API methods
asset = client.video.assets.create(request)
asset = client.video.assets.retrieve(asset_id)
assets_page = client.video.assets.list()
playback_id = client.video.assets.create_playback_id(asset_id, params)
```

### Delivery usage API

The `DeliveryUsageApi` API has been moved to `video.delivery_usage.list(**params)`

```python
import mux_python
client = mux_python.Configuration()
delivery_usage_api = mux_python.DeliveryUsageApi(mux_python.ApiClient(client))
delivery_usage = delivery_usage_api.list_delivery_usage()
```

```python
import mux_python
client = mux_python.Mux()
delivery_usage = client.video.delivery_usage.list()
```

### Live streams API

The `LiveStreamsApi` Methods have been renamed and reorganized under `client.video.live_streams`.

- `create_live_stream()` is now `create()`.
- `get_live_stream()` is now `retrieve()`.
- `update_live_stream()` is now `update()`.
- `list_live_streams()` is now `list()`.
- `delete_live_stream()` is now `delete()`.
- `signal_live_stream_complete()` is now `complete()`.
- `create_live_stream_playback_id()` is now `create_playback_id()`.
- `create_live_stream_simulcast_target()` is now `create_simulcast_target()`.
- `delete_live_stream_playback_id()` is now `delete_playback_id()`.
- `delete_live_stream_simulcast_target()` is now `delete_simulcast_target()`.
- `disable_live_stream()` is now `disable()`.
- `enable_live_stream()` is now `enable()`.
- `reset_stream_key()` remains the same.
- `get_live_stream_playback_id()` is now `retrieve_playback_id()`.
- `get_live_stream_simulcast_target()` is now `retrieve_simulcast_target()`.
- `update_live_stream_embedded_subtitles()` is now `update_embedded_subtitles()`.
- `update_live_stream_generated_subtitles()` is now `update_generated_subtitles()`.

Old example:

```python
import mux_python
client = mux_python.Configuration()
live_streams_api = mux_python.LiveStreamsApi(mux_python.ApiClient(client))
live_stream = live_streams_api.create_live_stream(create_live_stream_request)
live_streams = live_streams_api.list_live_streams()
live_stream = live_streams_api.get_live_stream(live_stream_id)
live_streams_api.delete_live_stream(live_stream_id)
```

New example:

```python
import mux_python
client = mux_python.Mux()
live_stream = client.video.live_streams.create(create_live_stream_request)
live_streams = client.video.live_streams.list()
live_stream = client.video.live_streams.retrieve(live_stream_id)
client.video.live_streams.delete(live_stream_id)
```

### Playback ID API

The `PlaybackIDApi` API has been moved to `client.video.playback_ids.retrieve(playback_id)`.

```python
import mux_python
client = mux_python.Configuration()
playback_id_api = mux_python.PlaybackIdApi(mux_python.ApiClient(client))
playback_id = playback_id_api.get_playback_id(playback_id)
```

```python
import mux_python
client = mux_python.Mux()
playback_id = client.video.playback_ids.retrieve(playback_id)
```

### Playback Restrictions API

The playback restrictions methods have been updated:

- `create_playback_restriction()` is now `client.video.playback_restrictions.create()`
- `get_playback_restriction()` is now `client.video.playback_restrictions.retrieve()`
- `list_playback_restrictions()` is now `client.video.playback_restrictions.list()`
- `delete_playback_restriction()` is now `client.video.playback_restrictions.delete()`
- `update_referrer_domain_restriction()` is now `client.video.playback_restrictions.update_referrer()`

Old example:

```python
import mux_python
client = mux_python.Configuration()
playback_restrictions_api = mux_python.PlaybackRestrictionsApi(mux_python.ApiClient(client))
playback_restriction = playback_restrictions_api.create_playback_restriction(playback_restriction_request)
playback_restriction = playback_restrictions_api.get_playback_restriction(playback_restriction_id)
playback_restrictions = playback_restrictions_api.list_playback_restrictions()
playback_restriction = playback_restrictions_api.delete_playback_restriction(playback_restriction_id)
playback_restriction = playback_restrictions_api.update_referrer_domain_restriction(playback_restriction_id, playback_restriction_request)
```

New example:

```python
import mux_python
client = mux_python.Mux()
playback_restriction = client.video.playback_restrictions.create(playback_restriction_request)
playback_restriction = client.video.playback_restrictions.retrieve(playback_restriction_id)
playback_restrictions = client.video.playback_restrictions.list()
playback_restriction = client.video.playback_restrictions.delete(playback_restriction_id)
playback_restriction = client.video.playback_restrictions.update_referrer(playback_restriction_id, playback_restriction_request)
```

### Spaces API

The `SpacesApi` API has been moved to `client.video.space` and the methods have been renamed:

- `create_space()` is now `create()`
- `get_space()` is now `retrieve()`
- `list_spaces()` is now `list()`
- `delete_space()` is now `delete()`
- `create_space_broadcast()` is now `create_broadcast()`
- `delete_space_broadcast()` is now `delete_broadcast()`
- `retrieve_space_broadcast()` is now `retrieve_broadcast()`
- `start_space_broadcast()` is now `start_broadcast()`
- `stop_space_broadcast()` is now `stop_broadcast()`

Old example:

```python
import mux_python
client = mux_python.Configuration()
spaces_api = mux_python.SpacesApi(mux_python.ApiClient(client))

# Use spaces
space = spaces_api.create_space(create_space_request)
space = spaces_api.get_space(space_id)
spaces = spaces_api.list_spaces()
spaces_api.delete_space(space_id)

# use broadcasts
broadcast = spaces_api.create_space_broadcast(space_id, create_broadcast_request)
spaces_api.delete_space_broadcast(space_id, broadcast_id)
broadcast = spaces_api.retrieve_space_broadcast(space_id, broadcast_id)
spaces_api.start_space_broadcast(space_id, broadcast_id)
spaces_api.stop_space_broadcast(space_id, broadcast_id)
```

New example:

```python
import mux_python
client = mux_python.Mux()

# Use spaces
space = client.video.space.create(create_space_request)
space = client.video.space.retrieve(space_id)
spaces = client.video.space.list()
client.video.space.delete(space_id)

# use broadcasts
broadcast = client.video.space.create_broadcast(space_id, create_broadcast_request)
client.video.space.delete_broadcast(space_id, broadcast_id)
broadcast = client.video.space.retrieve_broadcast(space_id, broadcast_id)
client.video.space.start_broadcast(space_id, broadcast_id)
client.video.space.stop_broadcast(space_id, broadcast_id)
```

### Transaction Vocabulary API

The `TranscriptionVocabulariesApi` class has been moved to `client.video.transcription_vocabularies` and methods have been renamed:

- `create_transcription_vocabulary()` is now `video.transaction_vocabularies.create()`
- `get_transcription_vocabulary()` is now `video.transaction_vocabularies.retrieve()`
- `update_transcription_vocabulary()` is now `video.transaction_vocabularies.update()`
- `list_transcription_vocabularies()` is now `video.transaction_vocabularies.list()`
- `delete_transcription_vocabulary()` is now `video.transaction_vocabularies.delete()`

Old example:

```python
import mux_python
client = mux_python.Configuration()
transcription_vocabularies_api = mux_python.TranscriptionVocabulariesApi(mux_python.ApiClient(client))
transcription_vocabulary = transcription_vocabularies_api.create_transcription_vocabulary(create_transcription_vocabulary_request)
transcription_vocabulary = transcription_vocabularies_api.get_transcription_vocabulary(transcription_vocabulary_id)
transcription_vocabularies = transcription_vocabularies_api.list_transcription_vocabularies()
transcription_vocabulary = transcription_vocabularies_api.delete_transcription_vocabulary(transcription_vocabulary_id)
```

New example:

```python
import mux_python
client = mux_python.Mux()
transcription_vocabulary = client.video.transcription_vocabularies.create(create_transcription_vocabulary_request)
transcription_vocabulary = client.video.transcription_vocabularies.retrieve(transcription_vocabulary_id)
transcription_vocabularies = client.video.transcription_vocabularies.list()
transcription_vocabulary = client.video.transcription_vocabularies.delete(transcription_vocabulary_id)
```

### Web Inputs API

The `WebInputsApi` class has been moved to `client.web_inputs.assets` and methods have been renamed:

- `create_web_input()` is now `web_inputs.assets.create()`
- `get_web_input()` is now `web_inputs.assets.retrieve()`
- `list_web_inputs()` is now `web_inputs.assets.list()`
- `delete_web_input()` is now `web_inputs.assets.delete()`
- `launch_web_input(id)` is now `web_inputs.assets.launch(id)`
- `reload_web_input(id)` is now `web_inputs.assets.reload(id)`
- `shutdown_web_input(id)` is now `web_inputs.assets.shutdown(id)`
- `update_web_input_url(id)` is now `web_inputs.assets.update_url(id)`

Example changes:

```python
import mux_python
client = mux_python.Configuration()
web_inputs_api = mux_python.WebInputsApi(mux_python.ApiClient(client))
web_input = web_inputs_api.create_web_input(create_web_input_request)
web_input = web_inputs_api.get_web_input(web_input_id)
web_inputs = web_inputs_api.list_web_inputs()
web_inputs_api.delete_web_input(web_input_id)
web_inputs_api.launch_web_input(web_input_id)
web_inputs_api.reload_web_input(web_input_id)
web_inputs_api.shutdown_web_input(web_input_id)
web_inputs_api.update_web_input_url(web_input_id, update_web_input_url_request)
```

```python
import mux_python
client = mux_python.Mux()
web_input = client.web_inputs.assets.create(create_web_input_request)
web_input = client.web_inputs.assets.retrieve(web_input_id)
web_inputs = client.web_inputs.assets.list()
client.web_inputs.assets.delete(web_input_id)
client.web_inputs.assets.launch(web_input_id)
client.web_inputs.assets.reload(web_input_id)
client.web_inputs.assets.shutdown(web_input_id)
client.web_inputs.assets.update_url(web_input_id, update_web_input_url_request)
```

### Dimensions API

The `DimensionsApi` class has been moved to `client.data.dimensions` and methods have been renamed:

- `list_dimensions()` is now `data.dimensions.list()`
- `list_dimension_values(id)` is now `data.dimensions.list_values(id)`

Example changes:

```python
import mux_python
client = mux_python.Configuration()
dimensions_api = mux_python.DimensionsApi(mux_python.ApiClient(client))
dimensions = dimensions_api.list_dimensions()
dimension_values = dimensions_api.list_dimension_values(dimension_id)
```

```python
import mux_python
client = mux_python.Mux()
dimensions = client.data.dimensions.list()
dimension_values = client.data.dimensions.list_values(dimension_id)
```

### Monitoring API

The `MonitoringApi` class has been moved to `client.data.monitoring.list_dimensions()`.

```python
import mux_python
client = mux_python.Configuration()
monitoring_api = mux_python.MonitoringApi(mux_python.ApiClient(client))
dimensions = monitoring_api.list_monitoring_dimensions()
```

```python
import mux_python
client = mux_python.Mux()
dimensions = client.data.monitoring.list_dimensions()
```

### Metrics API

The `MetricsApi` class has been moved to `client.data.monitoring.metrics` and methods have been renamed:

- `list_all_metric_values()` is now `data.monitoring.metrics.list()`
- `list_breakdown_values(id)` is now `data.monitoring.metrics.get_breakdown(id)`
- `get_metric_timeseries_data(id)` is now `data.monitoring.metrics.get_breakdown_timeseries(id)`
- `get_metric_values(id)` is now `data.monitoring.metrics.get_breakdown_values(id)`
- `get_metric_timeseries_data(id)` is now `data.monitoring.metrics.get_timeseries(id)`

Example changes:

```python
import mux_python
client = mux_python.Configuration()
metrics_api = mux_python.MetricsApi(mux_python.ApiClient(client))
metrics = metrics_api.list_all_metric_values()
breakdown_values = metrics_api.list_breakdown_values(metric_id)
timeseries_data = metrics_api.get_metric_timeseries_data(metric_id)
metric_values = metrics_api.get_metric_values(metric_id)
timeseries_data = metrics_api.get_metric_timeseries_data(metric_id)
```

```python
import mux_python
client = mux_python.Mux()
metrics = client.data.monitoring.metrics.list()
breakdown_values = client.data.monitoring.metrics.get_breakdown(metric_id)
timeseries_data = client.data.monitoring.metrics.get_breakdown_timeseries(metric_id)
metric_values = client.data.monitoring.metrics.get_breakdown_values(metric_id)
timeseries_data = client.data.monitoring.metrics.get_breakdown_timeseries(metric_id)
```

### Errors API

The `ErrorsApi` class has been moved to `client.data.errors.list()`.

```python
import mux_python

client = mux_python.Configuration()
errors_api = mux_python.ErrorsApi(mux_python.ApiClient(client))
errors = errors_api.list_errors()
```

```python
import mux_python

client = mux_python.Mux()
errors = client.data.errors.list()
```

### Filters API

The `FiltersApi` class has been moved to `client.data.filters.list_values(filter_id)`.

```python
import mux_python

client = mux_python.Configuration()
filters_api = mux_python.FiltersApi(mux_python.ApiClient(client))
filter_values = filters_api.list_values(filter_id)
```

```python
import mux_python

client = mux_python.Mux()
filter_values = client.data.filters.list_values(filter_id)
```

### Incidents API

The `IncidentsApi` class has been moved to `client.data.incidents` and methods have been renamed:

- `list_incidents()` is now `data.incidents.list()`
- `get_incident(id)` is now `data.incidents.retrieve(id)`
- `list_related_incidents(id)` is now `data.incidents.list_related(id)`

Example changes:

```python
import mux_python

client = mux_python.Configuration()
incidents_api = mux_python.IncidentsApi(mux_python.ApiClient(client))
incidents = incidents_api.list_incidents()
incident = incidents_api.get_incident(incident_id)
related_incidents = incidents_api.list_related_incidents(incident_id)
```

```python
import mux_python

client = mux_python.Mux()
incidents = client.data.incidents.list()
incident = client.data.incidents.retrieve(incident_id)
related_incidents = client.data.incidents.list_related(incident_id)
```

### RealTime API

The `RealTimeApi` class has been moved to `client.data.real_time` and methods have been renamed:

- `get_realtime_breakdown(id)` is now `data.real_time.retrieve_breakdown(id)`
- `list_realtime_dimensions()` is now `data.real_time.list_dimensions()`
- `list_realtime_metrics()` is now `data.real_time.list_metrics()`
- `get_realtime_histogram_timeseries(id)` is now `data.real_time.retrieve_histogram_timeseries(id)`
- `get_realtime_timeseries(id)` is now `data.real_time.retrieve_timeseries(id)`

Example changes:

```python
import mux_python

client = mux_python.Configuration()
real_time_api = mux_python.RealTimeApi(mux_python.ApiClient(client))
breakdown = real_time_api.get_realtime_breakdown(breakdown_id)
dimensions = real_time_api.list_realtime_dimensions()
metrics = real_time_api.list_realtime_metrics()
histogram_timeseries = real_time_api.get_realtime_histogram_timeseries(histogram_id)
timeseries = real_time_api.get_realtime_timeseries(timeseries_id)
```

```python
import mux_python

client = mux_python.Mux()
breakdown = client.data.real_time.retrieve_breakdown(breakdown_id)
dimensions = client.data.real_time.list_dimensions()
metrics = client.data.real_time.list_metrics()
histogram_timeseries = client.data.real_time.retrieve_histogram_timeseries(histogram_id)
timeseries = client.data.real_time.retrieve_timeseries(timeseries_id)
```
