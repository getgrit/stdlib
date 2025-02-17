---
title: Upgrade to Cloudflare v2
---

v2.x of the Go SDK is a ground-up rewrite, using code generation from the OpenAPI spec. There are significant breaking changes.

{% note %}
Note: Due to the massive rewrite, not all methods have a way to represent the previous method signatures or structs they relied on. Instead of writing a migration that will likely incorrectly identify these, we have instead provided the method renames which will allow you to inspect the method usage and what values it requires.

Future migrations will be more seamless as we will be automatically generating these based on version diffs instead.
{% /note %}


This migration can be applied automatically using the [Grit CLI](https://docs.grit.io/cli/quickstart):

```
grit apply cloudflare_go_v2
```


```grit
language go

pattern cloudflare_method_renaming() {
	field_identifier() as $method where $method <: or {
		`AccessAuditLogs` => `ZeroTrust.Access.Logs`,
		`ListHyperdriveConfigs` => `Hyperdrive.Configs.List`,
		`CreateHyperdriveConfig` => `Hyperdrive.Config.New`,
		`DeleteHyperdriveConfig` => `Hyperdrive.Config.Delete`,
		`GetHyperdriveConfig` => `Hyperdrive.Config.Get`,
		`UpdateHyperdriveConfig` => `Hyperdrive.Config.Update`,
		`CreateDevicePostureIntegration` => `ZeroTrust.Devices.Posture.Integrations.New`,
		`UpdateDevicePostureIntegration` => `ZeroTrust.Devices.Posture.Integrations.Update`,
		`DevicePostureIntegration` => `ZeroTrust.Devices.Posture.Integration.Get`,
		`DevicePostureIntegrations` => `ZeroTrust.Devices.Posture.Integrations.List`,
		`DeleteDevicePostureIntegration` => `ZeroTrust.Devices.Posture.Integrations.Delete`,
		`ListEmailRoutingDestinationAddresses` => `EmailRouting.Destination.Addresses.List`,
		`CreateEmailRoutingDestinationAddress` => `EmailRouting.Destination.Address.New`,
		`GetEmailRoutingDestinationAddress` => `EmailRouting.Destination.Address.Get`,
		`DeleteEmailRoutingDestinationAddress` => `EmailRouting.Destination.Address.Delete`,
		`DevicePostureRules` => `ZeroTrust.Devices.Postures.List`,
		`DevicePostureRule` => `ZeroTrust.Devices.Posture.Get`,
		`CreateDevicePostureRule` => `ZeroTrust.Devices.Posture.New`,
		`UpdateDevicePostureRule` => `ZeroTrust.Devices.Posture.Update`,
		`DeleteDevicePostureRule` => `ZeroTrust.Devices.Posture.Delete`,
		`ListR2Buckets` => `R2.Buckets.List`,
		`CreateR2Bucket` => `R2.Buckets.New`,
		`GetR2Bucket` => `R2.Buckets.Get`,
		`DeleteR2Bucket` => `R2.Buckets.Delete`,
		`DeleteWorker` => `Workers.Scripts.Delete`,
		`GetWorker` => `Workers.Scripts.Get`,
		`GetWorkerWithDispatchNamespace` => `WorkersForPlatforms.Dispatch.Namespaces.Scripts.Get`,
		`ListWorkers` => `Workers.Scripts.List`,
		`UploadWorker` => `Workers.Scripts.New`,
		`GetWorkersScriptContent` => `Workers.Scripts.Content.Get`,
		`UpdateWorkersScriptContent` => `Workers.Scripts.Content.Update`,
		`GetWorkersScriptSettings` => `Workers.Scripts.Settings.Get`,
		`UpdateWorkersScriptSettings` => `Workers.Scripts.Settings.Update`,
		`GetDLPPayloadLogSettings` => `ZeroTrust.DLP.PayloadLogs.Get`,
		`UpdateDLPPayloadLogSettings` => `ZeroTrust.DLP.PayloadLogs.Update`,
		`ListAccessCACertificates` => `ZeroTrust.Access.Applications.CAs.List`,
		`GetAccessCACertificate` => `ZeroTrust.Access.Applications.CAs.Get`,
		`CreateAccessCACertificate` => `ZeroTrust.Access.Applications.CAs.New`,
		`DeleteAccessCACertificate` => `ZeroTrust.Access.Applications.CAs.Delete`,
		`ListPageShieldScripts` => `PageShield.List`,
		`GetPageShieldScript` => `PageShield.Get`,
		`GetTotalTLS` => `ACM.TotalTLS.Get`,
		`SetTotalTLS` => `ACM.TotalTLS.New`,
		`RegistrarDomain` => `Registrar.Domains.Get`,
		`RegistrarDomains` => `Registrar.Domains.List`,
		`UpdateRegistrarDomain` => `Registrar.Domains.Update`,
		`CreateWorkersAccountSettings` => `Workers.AccountSettings.Update`,
		`WorkersAccountSettings` => `Workers.AccountSettings.Get`,
		`ListPermissionGroups` => `User.Tokens.PermissionGroups.List`,
		`ListMagicTransitIPsecTunnels` => `MagicTransit.IPSECTunnels.List`,
		`GetMagicTransitIPsecTunnel` => `MagicTransit.IPSECTunnels.Get`,
		`CreateMagicTransitIPsecTunnels` => `MagicTransit.IPSECTunnels.New`,
		`UpdateMagicTransitIPsecTunnel` => `MagicTransit.IPSECTunnels.Update`,
		`DeleteMagicTransitIPsecTunnel` => `MagicTransit.IPSECTunnels.Delete`,
		`GenerateMagicTransitIPsecTunnelPSK` => `MagicTransit.IPSECTunnels.PSKGenerate`,
		`CreateZoneHold` => `Zones.Holds.New`,
		`DeleteZoneHold` => `Zones.Holds.Delete`,
		`GetZoneHold` => `Zones.Holds.Get`,
		`ListZoneManagedHeaders` => `ManagedHeaders.List`,
		`UpdateZoneManagedHeaders` => `ManagedHeaders.Update`,
		`ListAccessPolicies` => `ZeroTrust.Access.Applications.Policies.List`,
		`GetAccessPolicy` => `ZeroTrust.Access.Applications.Policies.Get`,
		`CreateAccessPolicy` => `ZeroTrust.Access.Applications.Policies.New`,
		`UpdateAccessPolicy` => `ZeroTrust.Access.Applications.Policies.Update`,
		`DeleteAccessPolicy` => `ZeroTrust.Access.Applications.Policies.Delete`,
		`CreateSSL` => `CustomCertificates.New`,
		`ListSSL` => `CustomCertificates.List`,
		`SSLDetails` => `CustomCertificates.Get`,
		`UpdateSSL` => `CustomCertificates.Update`,
		`ReprioritizeSSL` => `CustomCertificates.Prioritize.Update`,
		`DeleteSSL` => `CustomCertificates.Delete`,
		`GetCustomNameservers` => `CustomNameservers.Get`,
		`CreateCustomNameservers` => `CustomNameservers.New`,
		`DeleteCustomNameservers` => `CustomNameservers.Delete`,
		`ListDexTests` => `ZeroTrust.Devices.DEXTests.List`,
		`CreateDeviceDexTest` => `ZeroTrust.Devices.DEXTests.New`,
		`UpdateDeviceDexTest` => `ZeroTrust.Devices.DEXTests.Update`,
		`GetDeviceDexTest` => `ZeroTrust.Devices.DEXTests.Get`,
		`DeleteDexTest` => `ZeroTrust.Devices.DEXTests.Delete`,
		`AccessBookmarks` => `ZeroTrust.Access.Bookmarks.List`,
		`ZoneLevelAccessBookmarks` => `ZeroTrust.Access.Bookmarks.List`,
		`AccessBookmark` => `ZeroTrust.Access.Bookmarks.Get`,
		`ZoneLevelAccessBookmark` => `ZeroTrust.Access.Bookmarks.Get`,
		`CreateAccessBookmark` => `ZeroTrust.Access.Bookmarks.New`,
		`CreateZoneLevelAccessBookmark` => `ZeroTrust.Access.Bookmarks.New`,
		`UpdateAccessBookmark` => `ZeroTrust.Access.Bookmarks.Update`,
		`UpdateZoneLevelAccessBookmark` => `ZeroTrust.Access.Bookmarks.Update`,
		`DeleteAccessBookmark` => `ZeroTrust.Access.Bookmarks.Delete`,
		`DeleteZoneLevelAccessBookmark` => `ZeroTrust.Access.Bookmarks.Delete`,
		`CreateZoneLockdown` => `Firewall.Lockdowns.New`,
		`UpdateZoneLockdown` => `Firewall.Lockdowns.Update`,
		`DeleteZoneLockdown` => `Firewall.Lockdowns.Delete`,
		`ZoneLockdown` => `Firewall.Lockdowns.Get`,
		`ListZoneLockdowns` => `Firewall.Lockdowns.List`,
		`GetRegionalTieredCache` => `Cache.RegionalTieredCache.Get`,
		`UpdateRegionalTieredCache` => `Cache.RegionalTieredCache.Edit`,
		`CreateWorkerRoute` => `Workers.Routes.New`,
		`DeleteWorkerRoute` => `Workers.Routes.Delete`,
		`ListWorkerRoutes` => `Workers.Routess.List`,
		`GetWorkerRoute` => `Workers.Routes.Get`,
		`UpdateWorkerRoute` => `Workers.Routes.Update`,
		`CreateWaitingRoom` => `WaitingRooms.New`,
		`ListWaitingRooms` => `WaitingRooms.List`,
		`WaitingRoom` => `WaitingRooms.Get`,
		`ChangeWaitingRoom` => `WaitingRooms.Edit`,
		`UpdateWaitingRoom` => `WaitingRooms.Update`,
		`DeleteWaitingRoom` => `WaitingRooms.Delete`,
		`WaitingRoomStatus` => `WaitingRooms.Status`,
		`WaitingRoomPagePreview` => `WaitingRooms.Page.Preview`,
		`CreateWaitingRoomEvent` => `WaitingRooms.Events.New`,
		`ListWaitingRoomEvents` => `WaitingRooms.Events.List`,
		`WaitingRoomEvent` => `WaitingRooms.Events.List`,
		`WaitingRoomEventPreview` => `WaitingRooms.Events.Preview`,
		`ChangeWaitingRoomEvent` => `WaitingRooms.Events.Edit`,
		`UpdateWaitingRoomEvent` => `WaitingRooms.Events.Update`,
		`DeleteWaitingRoomEvent` => `WaitingRooms.Events.Delete`,
		`ListWaitingRoomRules` => `WaitingRooms.Rules.List`,
		`CreateWaitingRoomRule` => `WaitingRooms.Rules.New`,
		`ReplaceWaitingRoomRules` => `WaitingRooms.Rules.Update`,
		`UpdateWaitingRoomRule` => `WaitingRooms.Rules.Edit`,
		`DeleteWaitingRoomRule` => `WaitingRooms.Rules.Delete`,
		`GetWaitingRoomSettings` => `WaitingRooms.Settings.Get`,
		`PatchWaitingRoomSettings` => `WaitingRooms.Settings.Edit`,
		`UpdateWaitingRoomSettings` => `WaitingRooms.Settings.Update`,
		`ListAccessMutualTLSCertificates` => `ZeroTrust.Access.Certificates.List`,
		`GetAccessMutualTLSCertificate` => `ZeroTrust.Access.Certificates.Get`,
		`CreateAccessMutualTLSCertificate` => `ZeroTrust.Access.Certificates.New`,
		`UpdateAccessMutualTLSCertificate` => `ZeroTrust.Access.Certificates.Update`,
		`DeleteAccessMutualTLSCertificate` => `ZeroTrust.Access.Certificates.Delete`,
		`GetAccessMutualTLSHostnameSettings` => `ZeroTrust.Access.Certificates.Settings.List`,
		`UpdateAccessMutualTLSHostnameSettings` => `ZeroTrust.Access.Certificates.Settings.Update`,
		`FirewallRules` => `Firewall.Rules.List`,
		`FirewallRule` => `Firewall.Rules.Get`,
		`CreateFirewallRules` => `Firewall.Rules.New`,
		`UpdateFirewallRule` => `Firewall.Rules.Update`,
		`UpdateFirewallRules` => `Firewall.Rules.Update`,
		`DeleteFirewallRule` => `Firewall.Rules.Delete`,
		`DeleteFirewallRules` => `Firewall.Rules.Delete`,
		`ListImagesVariants` => `Images.V1.Variants.List`,
		`GetImagesVariant` => `Images.V1.Variants.Get`,
		`CreateImagesVariant` => `Images.V1.Variants.New`,
		`DeleteImagesVariant` => `Images.V1.Variants.Delete`,
		`UpdateImagesVariant` => `Images.V1.Variants.Update`,
		`TeamsLocations` => `ZeroTrust.Gateway.Locations.List`,
		`TeamsLocation` => `ZeroTrust.Gateway.Locations.Get`,
		`CreateTeamsLocation` => `ZeroTrust.Gateway.Locations.New`,
		`UpdateTeamsLocation` => `ZeroTrust.Gateway.Locations.Update`,
		`DeleteTeamsLocation` => `ZeroTrust.Gateway.Locations.Delete`,
		`GetDCVDelegation` => `DCVDelegation.UUID.Get`,
		`ListPrefixes` => `Addressing.Prefixes.List`,
		`GetPrefix` => `Addressing.Prefixes.Get`,
		`UpdatePrefixDescription` => `Addressing.Prefixes.Update`,
		`GetAdvertisementStatus` => `Addressing.Prefixes.BGP.Statuses.Get`,
		`UpdateAdvertisementStatus` => `Addressing.Prefixes.BGP.Statuses.Edit`,
		`ListAccountRoles` => `Accounts.Roles.List`,
		`GetAccountRole` => `Accounts.Roles.Get`,
		`GetUserAuditLogs` => `User.AuditLogs.List`,
		`ListObservatoryPages` => `Speed.Pages.List`,
		`ArgoTunnels` => `ZeroTrust.Tunnels.List`,
		`ArgoTunnel` => `ZeroTrust.Tunnels.Get`,
		`CreateArgoTunnel` => `ZeroTrust.Tunnels.New`,
		`DeleteArgoTunnel` => `ZeroTrust.Tunnels.Delete`,
		`CleanupArgoTunnelConnections` => `ZeroTrust.Tunnels.Connections.Delete`,
		`CreateLogpushJob` => `Logpush.Jobs.New`,
		`ListLogpushJobs` => `Logpush.Jobs.List`,
		`GetLogpushJob` => `Logpush.Jobs.Get`,
		`UpdateLogpushJob` => `Logpush.Jobs.Update`,
		`DeleteLogpushJob` => `Logpush.Jobs.Delete`,
		`ListLogpushJobsForDataset` => `Logpush.Datasets.Jobs.Get`,
		`GetLogpushFields` => `Logpush.Datasets.Fields.Get`,
		`GetLogpushOwnershipChallenge` => `Logpush.Ownership.Get`,
		`ValidateLogpushOwnershipChallenge` => `Logpush.Ownership.Validate`,
		`CheckLogpushDestinationExists` => `Logpush.Validate.Destination`,
		`ListAccessGroups` => `ZeroTrust.Access.Groups.List`,
		`GetAccessGroup` => `ZeroTrust.Access.Groups.Get`,
		`CreateAccessGroup` => `ZeroTrust.Access.Groups.New`,
		`UpdateAccessGroup` => `ZeroTrust.Access.Groups.Update`,
		`DeleteAccessGroup` => `ZeroTrust.Access.Groups.Delete`,
		`ListAccessCustomPages` => `ZeroTrust.Access.CustomPages.List`,
		`GetAccessCustomPage` => `ZeroTrust.Access.CustomPages.Get`,
		`CreateAccessCustomPage` => `ZeroTrust.Access.CustomPages.New`,
		`DeleteAccessCustomPage` => `ZeroTrust.Access.CustomPages.Delete`,
		`UpdateAccessCustomPage` => `ZeroTrust.Access.CustomPages.Update`,
		`GetAuditSSHSettings` => `ZeroTrust.Gateway.AuditSSHSettings.Get`,
		`UpdateAuditSSHSettings` => `ZeroTrust.Gateway.AuditSSHSettings.Update`,
		`ListIPAccessRules` => `Firewall.AccessRules.List`,
		`SpectrumApplications` => `Spectrum.Apps.List`,
		`SpectrumApplication` => `Spectrum.Apps.Get`,
		`CreateSpectrumApplication` => `Spectrum.Apps.New`,
		`UpdateSpectrumApplication` => `Spectrum.Apps.Update`,
		`DeleteSpectrumApplication` => `Spectrum.Apps.Delete`,
		`CreateLoadBalancerPool` => `LoadBalancers.Pools.New`,
		`ListLoadBalancerPools` => `LoadBalancers.Poolss.List`,
		`GetLoadBalancerPool` => `LoadBalancers.Pools.Get`,
		`DeleteLoadBalancerPool` => `LoadBalancers.Pools.Delete`,
		`UpdateLoadBalancerPool` => `LoadBalancers.Pools.Update`,
		`CreateLoadBalancerMonitor` => `LoadBalancers.Monitors.New`,
		`ListLoadBalancerMonitors` => `LoadBalancers.Monitorss.List`,
		`GetLoadBalancerMonitor` => `LoadBalancers.Monitors.Get`,
		`DeleteLoadBalancerMonitor` => `LoadBalancers.Monitors.Delete`,
		`UpdateLoadBalancerMonitor` => `LoadBalancers.Monitors.Update`,
		`CreateLoadBalancer` => `LoadBalancers.New`,
		`ListLoadBalancers` => `LoadBalancerss.List`,
		`GetLoadBalancer` => `LoadBalancers.Get`,
		`DeleteLoadBalancer` => `LoadBalancers.Delete`,
		`UpdateLoadBalancer` => `LoadBalancers.Update`,
		`GetLoadBalancerPoolHealth` => `LoadBalancers.Pools.Health`,
		`CreateWorkersKVNamespace` => `KV.Namespaces.New`,
		`ListWorkersKVNamespaces` => `KV.Namespacess.List`,
		`DeleteWorkersKVNamespace` => `KV.Namespaces.Delete`,
		`UpdateWorkersKVNamespace` => `KV.Namespaces.Update`,
		`WriteWorkersKVEntries` => `KV.Namespaces.Bulk.Update`,
		`DeleteWorkersKVEntries` => `KV.Namespaces.Bulk.Delete`,
		`WriteWorkersKVEntry` => `KV.Namespaces.New`,
		`ListTunnelVirtualNetworks` => `ZeroTrust.Networks.VirtualNetworks.List`,
		`CreateTunnelVirtualNetwork` => `ZeroTrust.Networks.VirtualNetworks.New`,
		`DeleteTunnelVirtualNetwork` => `ZeroTrust.Networks.VirtualNetworks.Delete`,
		`UpdateTunnelVirtualNetwork` => `ZeroTrust.Networks.VirtualNetworks.Update`,
		`ListAccessTags` => `ZeroTrust.Access.Tags.List`,
		`GetAccessTag` => `ZeroTrust.Access.Tags.Get`,
		`CreateAccessTag` => `ZeroTrust.Access.Tags.New`,
		`DeleteAccessTag` => `ZeroTrust.Access.Tags.Delete`,
		`ListPageShieldPolicies` => `PageShield.Policies.List`,
		`CreatePageShieldPolicy` => `PageShield.Policies.New`,
		`DeletePageShieldPolicy` => `PageShield.Policies.Delete`,
		`GetPageShieldPolicy` => `PageShield.Policies.Get`,
		`UpdatePageShieldPolicy` => `PageShield.Policies.Update`,
		`ListAccessServiceTokens` => `ZeroTrust.Access.ServiceTokens.List`,
		`CreateAccessServiceToken` => `ZeroTrust.Access.ServiceTokens.New`,
		`UpdateAccessServiceToken` => `ZeroTrust.Access.ServiceTokens.Update`,
		`DeleteAccessServiceToken` => `ZeroTrust.Access.ServiceTokens.Delete`,
		`RefreshAccessServiceToken` => `ZeroTrust.Access.ServiceTokens.Refresh`,
		`RotateAccessServiceToken` => `ZeroTrust.Access.ServiceTokens.Rotate`,
		`ListMagicTransitGRETunnels` => `MagicTransit.GRETunnels.List`,
		`GetMagicTransitGRETunnel` => `MagicTransit.GRETunnels.Get`,
		`CreateMagicTransitGRETunnels` => `MagicTransit.GRETunnels.New`,
		`UpdateMagicTransitGRETunnel` => `MagicTransit.GRETunnels.Update`,
		`DeleteMagicTransitGRETunnel` => `MagicTransit.GRETunnels.Delete`,
		`ListEmailRoutingRules` => `EmailRouting.Routing.Rules.List`,
		`CreateEmailRoutingRule` => `EmailRouting.Routing.Rules.New`,
		`GetEmailRoutingRule` => `EmailRouting.Routing.Rules.Get`,
		`UpdateEmailRoutingRule` => `EmailRouting.Routing.Rules.Update`,
		`DeleteEmailRoutingRule` => `EmailRouting.Routing.Rules.Delete`,
		`GetEmailRoutingCatchAllRule` => `EmailRouting.Routing.Rules.CatchAlls.Get`,
		`UpdateEmailRoutingCatchAllRule` => `EmailRouting.Routing.Rules.CatchAlls.Update`,
		`Healthchecks` => `Healthchecks.List`,
		`Healthcheck` => `Healthchecks.Get`,
		`CreateHealthcheck` => `Healthchecks.New`,
		`UpdateHealthcheck` => `Healthchecks.Update`,
		`DeleteHealthcheck` => `Healthchecks.Delete`,
		`CreateHealthcheckPreview` => `Healthchecks.Previews.New`,
		`HealthcheckPreview` => `Healthchecks.Previews.Get`,
		`DeleteHealthcheckPreview` => `Healthchecks.Previews.Delete`,
		`UploadImage` => `Images.V1.New`,
		`UpdateImage` => `Images.V1.Update`,
		`CreateImageDirectUploadURL` => `Images.V2.DirectUploads.New`,
		`ListImages` => `Images.V1.List`,
		`GetImage` => `Images.V1.Get`,
		`DeleteImage` => `Images.V1.Delete`,
		`GetImagesStats` => `Images.V1.Stats.Get`,
		`ArgoSmartRouting` => `Argo.SmartRouting.Get`,
		`UpdateArgoSmartRouting` => `Argo.SmartRouting.Update`,
		`ArgoTieredCaching` => `Argo.TieredCaching.Get`,
		`UpdateArgoTieredCaching` => `Argo.TieredCaching.Edit`,
		`UniversalSSLSettingDetails` => `SSL.Universal.Settings.Get`,
		`EditUniversalSSLSetting` => `SSL.Universal.Settings.Edit`,
		`UniversalSSLVerificationDetails` => `SSL.Verification.Get`,
		`UpdateUniversalSSLCertificatePackValidationMethod` => `SSL.Verification.Edit`,
		`GetTieredCache` => `Cache.SmartTieredCache.Get`,
		`SetTieredCache` => `Cache.SmartTieredCache.Edit`,
		`DeleteTieredCache` => `Cache.SmartTieredCache.Delete`,
		`ListAccessIdentityProviders` => `ZeroTrust.IdentityProviders.List`,
		`GetAccessIdentityProvider` => `ZeroTrust.IdentityProviders.Get`,
		`CreateAccessIdentityProvider` => `ZeroTrust.IdentityProviders.New`,
		`UpdateAccessIdentityProvider` => `ZeroTrust.IdentityProviders.Update`,
		`DeleteAccessIdentityProvider` => `ZeroTrust.IdentityProviders.Delete`,
		`ListPagesDeployments` => `Pages.Projects.Deployments.List`,
		`GetPagesDeploymentInfo` => `Pages.Projects.Deployments.Get`,
		`GetPagesDeploymentLogs` => `Pages.Projects.Deployments.Logs.Get`,
		`DeletePagesDeployment` => `Pages.Projects.Deployments.Delete`,
		`CreatePagesDeployment` => `Pages.Projects.Deployments.New`,
		`RetryPagesDeployment` => `Pages.Projects.Deployments.Retry`,
		`RollbackPagesDeployment` => `Pages.Projects.Deployments.Rollback`,
		`CreateZone` => `Zones.New`,
		`ZoneActivationCheck` => `Zones.ActivationCheck.Trigger`,
		`ListZones` => `Zones.List`,
		`ZoneDetails` => `Zones.Get`,
		`ZoneSetPaused` => `Zones.Edit`,
		`ZoneSetType` => `Zones.Edit`,
		`ZoneSetVanityNS` => `Zones.Edit`,
		`ZoneSetPlan` => `Zones.Edit`,
		`ZoneUpdatePlan` => `Zones.Edit`,
		`EditZone` => `Zones.Edit`,
		`DeleteZone` => `Zones.Delete`,
		`PurgeEverything` => `Cache.Purge`,
		`PurgeCache` => `Cache.Purge`,
		`AvailableZoneRatePlans` => `AvailableRatePlans.Get`,
		`AvailableZonePlans` => `AvailablePlans.List`,
		`ZoneSettings` => `Zones.Settings.Get`,
		`UpdateZoneSettings` => `Zones.Settings.Update`,
		`ZoneSSLSettings` => `Zones.Settings.SSL.List`,
		`UpdateZoneSSLSettings` => `Zones.Settings.SSL.Edit`,
		`FallbackOrigin` => `CustomHostnames.FallbackOrigin.Get`,
		`UpdateFallbackOrigin` => `CustomHostnames.FallbackOrigin.Update`,
		`GetZoneSetting` => `Zones.Settings.Get`,
		`UpdateZoneSetting` => `Zones.Settings.Edit`,
		`ZoneExport` => `DNS.Records.Export`,
		`ZoneDNSSECSetting` => `DNSSEC.Get`,
		`DeleteZoneDNSSEC` => `DNSSEC.Delete`,
		`UpdateZoneDNSSEC` => `DNSSEC.Edit`,
		`ListCertificatePacks` => `SSL.CertificatePacks.List`,
		`CertificatePack` => `SSL.CertificatePacks.Get`,
		`CreateCertificatePack` => `SSL.CertificatePacks.New`,
		`DeleteCertificatePack` => `SSL.CertificatePacks.Delete`,
		`Filter` => `Filters.Get`,
		`Filters` => `Filters.List`,
		`CreateFilters` => `Filters.New`,
		`UpdateFilter` => `Filters.Update`,
		`UpdateFilters` => `Filters.Update`,
		`DeleteFilter` => `Filters.Delete`,
		`DeleteFilters` => `Filters.Delete`,
		`ListDLPProfiles` => `ZeroTrust.DLP.Profiles.List`,
		`GetDLPProfile` => `ZeroTrust.DLP.Profiles.Get`,
		`CreateDLPProfiles` => `ZeroTrust.DLP.Profiles.Custom.New`,
		`DeleteDLPProfile` => `ZeroTrust.DLP.Profiles.Custom.Delete`,
		`UpdateDLPProfile` => `ZeroTrust.DLP.Profiles.Custom.Update`,
		`ListAddressMaps` => `Addressing.AddressMaps.List`,
		`CreateAddressMap` => `Addressing.AddressMaps.New`,
		`GetAddressMap` => `Addressing.AddressMaps.Get`,
		`UpdateAddressMap` => `Addressing.AddressMaps.Update`,
		`DeleteAddressMap` => `Addressing.AddressMaps.Delete`,
		`CreateKeylessSSL` => `KeylessCertificates.New`,
		`ListKeylessSSL` => `KeylessCertificates.List`,
		`KeylessSSL` => `KeylessCertificates.Get`,
		`UpdateKeylessSSL` => `KeylessCertificates.Update`,
		`DeleteKeylessSSL` => `KeylessCertificates.Delete`,
		`GetBotManagement` => `BotManagement.Get`,
		`UpdateBotManagement` => `BotManagement.Update`,
		`ZoneCacheVariants` => `Cache.Variants.Get`,
		`UpdateZoneCacheVariants` => `Cache.Variants.Update`,
		`DeleteZoneCacheVariants` => `Cache.Variants.Delete`,
		`ListPagesProjects` => `Pages.Projects.List`,
		`GetPagesProject` => `Pages.Projects.Get`,
		`CreatePagesProject` => `Pages.Projects.New`,
		`UpdatePagesProject` => `Pages.Projects.Edit`,
		`DeletePagesProject` => `Pages.Projects.Delete`,
		`UpdateAccessUserSeat` => `ZeroTrust.Seats.Edit`,
		`UpdateAccessUsersSeats` => `ZeroTrust.Seats.Edit`,
		`ListWAFOverrides` => `Firewall.WAF.Overrides.List`,
		`WAFOverride` => `Firewall.WAF.Overrides.Get`,
		`CreateWAFOverride` => `Firewall.WAF.Overrides.New`,
		`UpdateWAFOverride` => `Firewall.WAF.Overrides.Update`,
		`DeleteWAFOverride` => `Firewall.WAF.Overrides.Delete`,
		`EnableEmailRouting` => `EmailRouting.Routing.Enable`,
		`DisableEmailRouting` => `EmailRouting.Routing.Disable`,
		`GetEmailRoutingDNSSettings` => `EmailRouting.Routing.DNS.Get`,
		`GetPageShieldSettings` => `PageShield.Get`,
		`UpdatePageShieldSettings` => `PageShield.Update`,
		`CreatePageRule` => `Pagerules.New`,
		`ListPageRules` => `Pagerules.List`,
		`PageRule` => `Pagerules.Get`,
		`ChangePageRule` => `Pagerules.Edit`,
		`UpdatePageRule` => `Pagerules.Update`,
		`DeletePageRule` => `Pagerules.Delete`,
		`PerformTraceroute` => `Diagnostics.Traceroutes.New`,
		`AccountMembers` => `Accounts.Members.List`,
		`CreateAccountMember` => `Accounts.Members.New`,
		`DeleteAccountMember` => `Accounts.Members.Delete`,
		`UpdateAccountMember` => `Accounts.Members.Update`,
		`AccountMember` => `Accounts.Members.Get`,
		`GetCacheReserve` => `Cache.CacheReserve.Get`,
		`UpdateCacheReserve` => `Cache.CacheReserve.Update`,
		`ListDeviceManagedNetworks` => `ZeroTrust.Devices.Networks.List`,
		`CreateDeviceManagedNetwork` => `ZeroTrust.Devices.Networks.New`,
		`UpdateDeviceManagedNetwork` => `ZeroTrust.Devices.Networks.Update`,
		`GetDeviceManagedNetwork` => `ZeroTrust.Devices.Networks.Get`,
		`DeleteManagedNetworks` => `ZeroTrust.Devices.Networks.Delete`,
		`WorkersCreateSubdomain` => `Workers.Subdomains.Update`,
		`WorkersGetSubdomain` => `Workers.Subdomains.Get`,
		`ListMagicTransitStaticRoutes` => `MagicTransit.Routes.List`,
		`GetMagicTransitStaticRoute` => `MagicTransit.Routes.Get`,
		`CreateMagicTransitStaticRoute` => `MagicTransit.Routes.New`,
		`UpdateMagicTransitStaticRoute` => `MagicTransit.Routes.Update`,
		`DeleteMagicTransitStaticRoute` => `MagicTransit.Routes.Delete`,
		`ListTunnelRoutes` => `ZeroTrust.Networks.Routes.List`,
		`GetTunnelRouteForIP` => `ZeroTrust.Networks.Routes.Get`,
		`CreateTunnelRoute` => `ZeroTrust.Networks.Routes.New`,
		`DeleteTunnelRoute` => `ZeroTrust.Networks.Routes.Delete`,
		`UpdateTunnelRoute` => `ZeroTrust.Networks.Routes.Update`,
		`ListPerHostnameAuthenticatedOriginPullsCertificates` => `OriginTLSClientAuth.Hostnames.Certificates.List`,
		`UploadPerHostnameAuthenticatedOriginPullsCertificate` => `OriginTLSClientAuth.Hostnames.Certificates.New`,
		`GetPerHostnameAuthenticatedOriginPullsCertificate` => `OriginTLSClientAuth.Hostnames.Certificates.Get`,
		`DeletePerHostnameAuthenticatedOriginPullsCertificate` => `OriginTLSClientAuth.Hostnames.Certificates.Delete`,
		`ForceSecondaryDNSZoneAXFR` => `SecondaryDNS.ForceAXFR`,
		`ListWorkerCronTriggers` => `Workers.Scripts.Schedules.Get`,
		`UpdateWorkerCronTriggers` => `Workers.Scripts.Schedules.Update`,
		`GetAPIToken` => `User.Tokens.Get`,
		`APITokens` => `User.Tokens.List`,
		`CreateAPIToken` => `User.Tokens.New`,
		`UpdateAPIToken` => `User.Tokens.Update`,
		`VerifyAPIToken` => `User.Tokens.Verify`,
		`DeleteAPIToken` => `User.Tokens.Delete`,
		`ListAPITokensPermissionGroups` => `User.Tokens.PermissionGroups.List`,
		`TeamsProxyEndpoint` => `ZeroTrust.Gateway.ProxyEndpoints.Get`,
		`TeamsProxyEndpoints` => `ZeroTrust.Gateway.ProxyEndpoints.List`,
		`CreateTeamsProxyEndpoint` => `ZeroTrust.Gateway.ProxyEndpoints.New`,
		`UpdateTeamsProxyEndpoint` => `ZeroTrust.Gateway.ProxyEndpoints.Update`,
		`DeleteTeamsProxyEndpoint` => `ZeroTrust.Gateway.ProxyEndpoints.Delete`,
		`ListAccessApplications` => `ZeroTrust.Access.Applications.List`,
		`GetAccessApplication` => `ZeroTrust.Access.Applications.Get`,
		`CreateAccessApplication` => `ZeroTrust.Access.Applications.New`,
		`UpdateAccessApplication` => `ZeroTrust.Access.Applications.Update`,
		`DeleteAccessApplication` => `ZeroTrust.Access.Applications.Delete`,
		`RevokeAccessApplicationTokens` => `ZeroTrust.Access.Applications.RevokeTokens`,
		`TeamsRules` => `ZeroTrust.Gateway.Rules.List`,
		`TeamsRule` => `ZeroTrust.Gateway.Rules.Get`,
		`TeamsCreateRule` => `ZeroTrust.Gateway.Rules.New`,
		`TeamsUpdateRule` => `ZeroTrust.Gateway.Rules.Update`,
		`TeamsPatchRule` => `ZeroTrust.Gateway.Rules.Edit`,
		`TeamsDeleteRule` => `ZeroTrust.Gateway.Rules.Delete`,
		`ListTeamsLists` => `ZeroTrust.Gateway.Lists.List`,
		`GetTeamsList` => `ZeroTrust.Gateway.Lists.Get`,
		`ListTeamsListItems` => `ZeroTrust.Gateway.Lists.Items.List`,
		`CreateTeamsList` => `ZeroTrust.Gateway.Lists.New`,
		`UpdateTeamsList` => `ZeroTrust.Gateway.Lists.Update`,
		`PatchTeamsList` => `ZeroTrust.Gateway.Lists.Edit`,
		`DeleteTeamsList` => `ZeroTrust.Gateway.Lists.Delete`,
		`ListDLPDatasets` => `ZeroTrust.DLP.Datasets.List`,
		`GetDLPDataset` => `ZeroTrust.DLP.Datasets.Get`,
		`CreateDLPDataset` => `ZeroTrust.DLP.Datasets.New`,
		`DeleteDLPDataset` => `ZeroTrust.DLP.Datasets.Delete`,
		`UpdateDLPDataset` => `ZeroTrust.DLP.Datasets.Update`,
		`CreateDLPDatasetUpload` => `ZeroTrust.DLP.Datasets.Upload.New`,
		`GetSecondaryDNSTSIG` => `SecondaryDNS.TSIGs.Get`,
		`ListSecondaryDNSTSIGs` => `SecondaryDNS.TSIGs.List`,
		`CreateSecondaryDNSTSIG` => `SecondaryDNS.TSIGs.New`,
		`UpdateSecondaryDNSTSIG` => `SecondaryDNS.TSIGs.Update`,
		`DeleteSecondaryDNSTSIG` => `SecondaryDNS.TSIGs.Delete`,
		`UpdateDeviceClientCertificates` => `Device.Client.Certificates.Update`,
		`GetDeviceClientCertificates` => `Device.Client.Certificates.Get`,
		`CreateDeviceSettingsPolicy` => `ZeroTrust.Devices.Policies.New`,
		`UpdateDefaultDeviceSettingsPolicy` => `ZeroTrust.Devices.Policies.DefaultPolicy.Update`,
		`GetDefaultDeviceSettingsPolicy` => `ZeroTrust.Devices.Policies.DefaultPolicy.Get`,
		`UpdateDeviceSettingsPolicy` => `ZeroTrust.Devices.Policies.Update`,
		`DeleteDeviceSettingsPolicy` => `ZeroTrust.Devices.Policies.Delete`,
		`GetDeviceSettingsPolicy` => `ZeroTrust.Devices.Policies.Get`,
		`ListDeviceSettingsPolicies` => `Device.Settings.Policies.List`,
		`URLNormalizationSettings` => `URLNormalization.Get`,
		`UpdateURLNormalizationSettings` => `URLNormalization.Update`,
		`UpdateCustomHostnameSSL` => `CustomHostnames.Update`,
		`UpdateCustomHostname` => `CustomHostnames.Update`,
		`DeleteCustomHostname` => `CustomHostnames.Delete`,
		`CreateCustomHostname` => `CustomHostnames.New`,
		`CustomHostnames` => `CustomHostnames.List`,
		`CustomHostname` => `CustomHostnames.Get`,
		`UpdateCustomHostnameFallbackOrigin` => `CustomHostnames.FallbackOrigin.Update`,
		`DeleteCustomHostnameFallbackOrigin` => `CustomHostnames.FallbackOrigin.Delete`,
		`CustomHostnameFallbackOrigin` => `CustomHostnames.FallbackOrigin.Get`,
		`GetAccessOrganization` => `ZeroTrust.Organizations.Get`,
		`CreateAccessOrganization` => `ZeroTrust.Organizations.New`,
		`UpdateAccessOrganization` => `ZeroTrust.Organizations.Update`,
		`ListFallbackDomains` => `ZeroTrust.Devices.Policies.FallbackDomains.List`,
		`UpdateFallbackDomain` => `ZeroTrust.Devices.Policies.FallbackDomains.Update`,
		`ListTeamsDevices` => `ZeroTrust.Devices.List`,
		`RevokeTeamsDevices` => `ZeroTrust.Devices.Revokes.New`,
		`GetTeamsDeviceDetails` => `ZeroTrust.Devices.Get`,
		`ListTunnels` => `ZeroTrust.Tunnels.List`,
		`GetTunnel` => `ZeroTrust.Tunnels.Get`,
		`CreateTunnel` => `ZeroTrust.Tunnels.New`,
		`UpdateTunnel` => `ZeroTrust.Tunnels.Update`,
		`UpdateTunnelConfiguration` => `ZeroTrust.Tunnels.Configurations.Update`,
		`GetTunnelConfiguration` => `ZeroTrust.Tunnels.Configurations.Get`,
		`ListTunnelConnections` => `ZeroTrust.Tunnels.Configurations.List`,
		`DeleteTunnel` => `ZeroTrust.Tunnels.Delete`,
		`CleanupTunnelConnections` => `ZeroTrust.Tunnels.Connections.Delete`,
		`GetTunnelToken` => `ZeroTrust.Tunnels.Token.Get`,
		`ListQueues` => `Queues.List`,
		`CreateQueue` => `Queues.New`,
		`DeleteQueue` => `Queues.Delete`,
		`GetQueue` => `Queues.Get`,
		`UpdateQueue` => `Queues.Update`,
		`ListQueueConsumers` => `Queues.Consumers.List`,
		`CreateQueueConsumer` => `Queues.Consumers.New`,
		`DeleteQueueConsumer` => `Queues.Consumers.Delete`,
		`UpdateQueueConsumer` => `Queues.Consumers.Update`,
		`ListD1Databases` => `D1.Database.List`,
		`CreateD1Database` => `D1.Database.New`,
		`DeleteD1Database` => `D1.Database.Delete`,
		`GetD1Database` => `D1.Database.Get`,
		`QueryD1Database` => `D1.Database.Query`,
		`ListAccessUsers` => `ZeroTrust.Access.Users.List`,
		`GetAccessUserActiveSessions` => `ZeroTrust.Access.Users.ActiveSessions.List`,
		`GetAccessUserFailedLogins` => `ZeroTrust.Access.Users.FailedLogins.List`,
		`GetAccessUserLastSeenIdentity` => `ZeroTrust.Access.Users.LastSeenIdentity.Get`,
		`CreateUserAgentRule` => `Firewall.UARules.New`,
		`UpdateUserAgentRule` => `Firewall.UARules.Update`,
		`DeleteUserAgentRule` => `Firewall.UARules.Delete`,
		`UserAgentRule` => `Firewall.UARules`,
		`ListUserAgentRules` => `Firewall.UARules.List`,
		`ListIPAccessRules` => `Firewall.AccessRules.List`,
		`UserDetails` => `User.Get`,
		`UpdateUser` => `User.Edit`,
		`UserBillingProfile` => `User.Billing.Profile.Get`,
		`UserBillingHistory` => `User.Billing.History.Get`,
		`CreateTurnstileWidget` => `Challenges.Widgets.New`,
		`ListTurnstileWidgets` => `Challenges.Widgets.List`,
		`GetTurnstileWidget` => `Challenges.Widgets.Get`,
		`UpdateTurnstileWidget` => `Challenges.Widgets.Update`,
		`RotateTurnstileWidget` => `Challenges.Widgets.RotateSecret`,
		`DeleteTurnstileWidget` => `Challenges.Widgets.Delete`,
		`ListWorkersDomains` => `Workers.Domains.List`,
		`AttachWorkersDomain` => `Workers.Domains.Update`,
		`GetWorkersDomain` => `Workers.Domains.Get`,
		`DetachWorkersDomain` => `Workers.Domains.Delete`,
		`GetLogpullRetentionFlag` => `Logs.Control.Retention.Flag.Get`,
		`SetLogpullRetentionFlag` => `Logs.Control.Retention.Flag.Set`,
		`CreateRateLimit` => `RateLimits.New`,
		`ListRateLimits` => `RateLimits.List`,
		`ListAllRateLimits` => `RateLimits.List`,
		`RateLimit` => `RateLimits.Get`,
		`UpdateRateLimit` => `RateLimits.Update`,
		`DeleteRateLimit` => `RateLimits.Delete`,
		`GetPagesDomains` => `Pages.Projects.Domains.List`,
		`GetPagesDomain` => `Pages.Projects.Domains.Get`,
		`PagesPatchDomain` => `Pages.Projects.Domains.Edit`,
		`PagesAddDomain` => `Pages.Projects.Domains.New`,
		`PagesDeleteDomain` => `Pages.Projects.Domains.Delete`,
		`ListMTLSCertificates` => `MTLSCertificates.List`,
		`GetMTLSCertificate` => `MTLSCertificates.Get`,
		`ListMTLSCertificateAssociations` => `MTLSCertificates.Associations.Get`,
		`CreateMTLSCertificate` => `MTLSCertificates.New`,
		`DeleteMTLSCertificate` => `MTLSCertificates.Delete`,
		`CreateDNSRecord` => `DNS.Records.New`,
		`ListDNSRecords` => `DNS.Records.List`,
		`GetDNSRecord` => `DNS.Records.Get`,
		`UpdateDNSRecord` => `DNS.Records.Update`,
		`DeleteDNSRecord` => `DNS.Records.Delete`,
		`ExportDNSRecords` => `DNS.Records.Export`,
		`ImportDNSRecords` => `DNS.Records.Import`,
		`TeamsAccount` => `ZeroTrust.Gateway.Get`,
		`TeamsAccountConfiguration` => `ZeroTrust.Gateway.Configurations.Get`,
		`TeamsAccountDeviceConfiguration` => `Teams.Account.Device.Configuration.Get`,
		`TeamsAccountUpdateConfiguration` => `ZeroTrust.Gateway.Configurations.Update`,
		`TeamsAccountLoggingConfiguration` => `ZeroTrust.Gateway.Configurations.Logging.Get`,
		`TeamsAccountUpdateLoggingConfiguration` => `ZeroTrust.Gateway.Configurations.Logging.Set`,
		`ListUserAccessRules` => `User.Firewall.AccessRules.List`,
		`CreateUserAccessRule` => `User.Firewall.AccessRules.New`,
		`UserAccessRule` => `User.Firewall.AccessRules.Get`,
		`UpdateUserAccessRule` => `User.Firewall.AccessRules.Update`,
		`DeleteUserAccessRule` => `User.Firewall.AccessRules.Delete`,
		`ListZoneAccessRules` => `Firewall.AccessRules.List`,
		`CreateZoneAccessRule` => `Firewall.AccessRules.New`,
		`ZoneAccessRule` => `Firewall.AccessRules.Get`,
		`UpdateZoneAccessRule` => `Firewall.AccessRules.Update`,
		`DeleteZoneAccessRule` => `Firewall.AccessRules.Delete`,
		`ListAccountAccessRules` => `Firewall.AccessRules.List`,
		`CreateAccountAccessRule` => `AFirewall.AccessRules.New`,
		`AccountAccessRule` => `Firewall.AccessRules.Rule.Get`,
		`UpdateAccountAccessRule` => `Firewall.AccessRules.Rule.Update`,
		`DeleteAccountAccessRule` => `Firewall.AccessRules.Rule.Delete`,
		`ListWorkerBindings` => `Workers.Scripts.Bindings.Get`,
		`AccessKeysConfig` => `ZeroTrust.Access.Keys.List`,
		`UpdateAccessKeysConfig` => `ZeroTrust.Access.Keys.Update`,
		`RotateAccessKeys` => `ZeroTrust.Access.Keys.Rotate`,
		`ListLists` => `Rules.Lists.List`,
		`CreateList` => `Rules.Lists.New`,
		`GetList` => `Rules.Lists.Get`,
		`UpdateList` => `Rules.Lists.Update`,
		`DeleteList` => `Rules.Lists.Delete`,
		`ListListItems` => `Rules.ListsItems.List`,
		`CreateListItem` => `Rules.Lists.Items.New`,
		`CreateListItems` => `Rules.Lists.Items.New`,
		`ReplaceListItems` => `Rules.Lists.Items.Update`,
		`DeleteListItems` => `Rules.Lists.Items.Delete`,
		`GetListItem` => `Rules.Lists.Items.Get`,
		`GetListBulkOperation` => `Rules.Lists.BulkOperations.Get`,
		`ListWAFPackages` => `Firewall.WAF.Packages.List`,
		`WAFPackage` => `Firewall.WAF.Packages.Get`,
		`UpdateWAFPackage` => `Firewall.WAF.Packages.Update`,
		`ListWAFGroups` => `Firewall.WAF.Groups.List`,
		`WAFGroup` => `Firewall.WAF.Groups.Get`,
		`UpdateWAFGroup` => `Firewall.WAF.Groups.Update`,
		`ListWAFRules` => `Firewall.WAF.Packages.Rules.List`,
		`WAFRule` => `Firewall.WAF.Packages.Rules`,
		`UpdateWAFRule` => `Firewall.WAF.Packages.Rules.Update`,
		`ListRulesets` => `Rulesets.List`,
		`GetRuleset` => `Rulesets.Get`,
		`CreateRuleset` => `Rulesets.New`,
		`DeleteRuleset` => `Rulesets.Delete`,
		`UpdateRuleset` => `Rulesets.Update`,
		`Accounts` => `Accounts.List`,
		`Account` => `Accounts.Get`,
		`UpdateAccount` => `Accounts.Update`,
		`CreateAccount` => `Accounts.New`,
		`DeleteAccount` => `Accounts.Delete`,
		`CreateOriginCACertificate` => `OriginCACertificates.New`,
		`ListOriginCACertificates` => `OriginCACertificates.List`,
		`GetOriginCACertificate` => `OriginCACertificates.Get`,
		`RevokeOriginCACertificate` => `OriginCACertificates.Delete`,
		`CreateDNSFirewallCluster` => `DNS.Firewall.New`,
		`GetDNSFirewallCluster` => `DNS.Firewall.Get`,
		`ListDNSFirewallClusters` => `DNS.Firewall.List`,
		`UpdateDNSFirewallCluster` => `DNS.Firewall.Update`,
		`DeleteDNSFirewallCluster` => `DNS.Firewall.Delete`,
		`GetDNSFirewallUserAnalytics` => `DNS.Firewall.Analytics.Reports.Get`,
		`ListHostnameTLSSettings` => `OriginTLSClientAuth.Settings.Get`,
		`UpdateHostnameTLSSetting` => `OriginTLSClientAuth.Settings.Update`,
		`ListHostnameTLSSettingsCiphers` => `Hostname.TLSSettings.Ciphers.List`,
		`UpdateHostnameTLSSettingCiphers` => `Hostname.TLSSetting.Ciphers.Update`,
		`DeleteHostnameTLSSettingCiphers` => `Hostname.TLSSetting.Ciphers.Delete`
	}
}

pattern cloudflare_client_constructor() {
	or {
		`cloudflare.New($api_key, $api_email)` => `cloudflare.NewClient(
      option.WithAPIKey($api_key),
      option.WithAPIEmail($api_email),
    )`,
		`cloudflare.NewWithAPIToken($api_token)` => `cloudflare.NewClient(option.WithAPIToken($api_token))`,
		`cloudflare.NewWithUserServiceKey($user_service_key)` => `cloudflare.NewClient(option.WithUserServiceKey($user_service_key))`
	} as $init where {
		$init <: maybe within `$api, $err := $init` => `$api := $init`
	}
}

// The main pattern body
file($body) where {
	$body <: contains or {
		cloudflare_client_constructor(),
		cloudflare_method_renaming()
	}
}
```

## Client construction with API key and email

Old:

```go
package main

func main() {
  api, err := cloudflare.New(os.Getenv("CLOUDFLARE_API_KEY"), os.Getenv("CLOUDFLARE_API_EMAIL"))
}
```

New:

```go
package main

func main() {
  api := cloudflare.NewClient(
    option.WithAPIKey(os.Getenv("CLOUDFLARE_API_KEY")),
    option.WithAPIEmail(os.Getenv("CLOUDFLARE_API_EMAIL")),
  )
}
```

## Client construction with API token

Old:

```go
package main

func main() {
  api, err := cloudflare.NewWithAPIToken(os.Getenv("CLOUDFLARE_API_TOKEN"))
}
```

New:

```go
package main

func main() {
  api := cloudflare.NewClient(option.WithAPIToken(os.Getenv("CLOUDFLARE_API_TOKEN")))
}
```

## Client construction with user service key

Old:

```go
package main

func main() {
  api, err := cloudflare.NewWithUserServiceKey(os.Getenv("CLOUDFLARE_USER_SERVICE_KEY"))
}
```

New:

```go
package main

func main() {
  api := cloudflare.NewClient(option.WithUserServiceKey(os.Getenv("CLOUDFLARE_USER_SERVICE_KEY")))
}
```

## Method renames

Many methods were renamed across APIs. Here is an example from the workers KV API:

```go
func CreateWorkersKVNamespace(api *cloudflare.API, OrganizationId string, Name string) (resp interface{}, err error) {
  resp, err = api.CreateWorkersKVNamespace(context.TODO(), &cloudflare.WorkersKVNamespaceRequest{Title: Name})
  return
}
```

```go
func CreateWorkersKVNamespace(api *cloudflare.API, OrganizationId string, Name string) (resp interface{}, err error) {
  resp, err = api.KV.Namespaces.New(context.TODO(), &cloudflare.WorkersKVNamespaceRequest{Title: Name})
  return
}
```

The full list of renamed methods includes:

- AccessAuditLogs -> ZeroTrust.Access.Logs
- ListHyperdriveConfigs -> Hyperdrive.Configs.List
- CreateHyperdriveConfig -> Hyperdrive.Config.New
- DeleteHyperdriveConfig -> Hyperdrive.Config.Delete
- GetHyperdriveConfig -> Hyperdrive.Config.Get
- UpdateHyperdriveConfig -> Hyperdrive.Config.Update
- CreateDevicePostureIntegration -> ZeroTrust.Devices.Posture.Integrations.New
- UpdateDevicePostureIntegration -> ZeroTrust.Devices.Posture.Integrations.Update
- DevicePostureIntegration -> ZeroTrust.Devices.Posture.Integration.Get
- DevicePostureIntegrations -> ZeroTrust.Devices.Posture.Integrations.List
- DeleteDevicePostureIntegration -> ZeroTrust.Devices.Posture.Integrations.Delete
- ListEmailRoutingDestinationAddresses -> EmailRouting.Destination.Addresses.List
- CreateEmailRoutingDestinationAddress -> EmailRouting.Destination.Address.New
- GetEmailRoutingDestinationAddress -> EmailRouting.Destination.Address.Get
- DeleteEmailRoutingDestinationAddress -> EmailRouting.Destination.Address.Delete
- DevicePostureRules -> ZeroTrust.Devices.Postures.List
- DevicePostureRule -> ZeroTrust.Devices.Posture.Get
- CreateDevicePostureRule -> ZeroTrust.Devices.Posture.New
- UpdateDevicePostureRule -> ZeroTrust.Devices.Posture.Update
- DeleteDevicePostureRule -> ZeroTrust.Devices.Posture.Delete
- ListR2Buckets -> R2.Buckets.List
- CreateR2Bucket -> R2.Buckets.New
- GetR2Bucket -> R2.Buckets.Get
- DeleteR2Bucket -> R2.Buckets.Delete
- DeleteWorker -> Workers.Scripts.Delete
- GetWorker -> Workers.Scripts.Get
- GetWorkerWithDispatchNamespace -> WorkersForPlatforms.Dispatch.Namespaces.Scripts.Get
- ListWorkers -> Workers.Scripts.List
- UploadWorker -> Workers.Scripts.New
- GetWorkersScriptContent -> Workers.Scripts.Content.Get
- UpdateWorkersScriptContent -> Workers.Scripts.Content.Update
- GetWorkersScriptSettings -> Workers.Scripts.Settings.Get
- UpdateWorkersScriptSettings -> Workers.Scripts.Settings.Update
- GetDLPPayloadLogSettings -> ZeroTrust.DLP.PayloadLogs.Get
- UpdateDLPPayloadLogSettings -> ZeroTrust.DLP.PayloadLogs.Update
- ListAccessCACertificates -> ZeroTrust.Access.Applications.CAs.List
- GetAccessCACertificate -> ZeroTrust.Access.Applications.CAs.Get
- CreateAccessCACertificate -> ZeroTrust.Access.Applications.CAs.New
- DeleteAccessCACertificate -> ZeroTrust.Access.Applications.CAs.Delete
- ListPageShieldScripts -> PageShield.List
- GetPageShieldScript -> PageShield.Get
- GetTotalTLS -> ACM.TotalTLS.Get
- SetTotalTLS -> ACM.TotalTLS.New
- RegistrarDomain -> Registrar.Domains.Get
- RegistrarDomains -> Registrar.Domains.List
- UpdateRegistrarDomain -> Registrar.Domains.Update
- CreateWorkersAccountSettings -> Workers.AccountSettings.Update
- WorkersAccountSettings -> Workers.AccountSettings.Get
- ListPermissionGroups -> User.Tokens.PermissionGroups.List
- ListMagicTransitIPsecTunnels -> MagicTransit.IPSECTunnels.List
- GetMagicTransitIPsecTunnel -> MagicTransit.IPSECTunnels.Get
- CreateMagicTransitIPsecTunnels -> MagicTransit.IPSECTunnels.New
- UpdateMagicTransitIPsecTunnel -> MagicTransit.IPSECTunnels.Update
- DeleteMagicTransitIPsecTunnel -> MagicTransit.IPSECTunnels.Delete
- GenerateMagicTransitIPsecTunnelPSK -> MagicTransit.IPSECTunnels.PSKGenerate
- CreateZoneHold -> Zones.Holds.New
- DeleteZoneHold -> Zones.Holds.Delete
- GetZoneHold -> Zones.Holds.Get
- ListZoneManagedHeaders -> ManagedHeaders.List
- UpdateZoneManagedHeaders -> ManagedHeaders.Update
- ListAccessPolicies -> ZeroTrust.Access.Applications.Policies.List
- GetAccessPolicy -> ZeroTrust.Access.Applications.Policies.Get
- CreateAccessPolicy -> ZeroTrust.Access.Applications.Policies.New
- UpdateAccessPolicy -> ZeroTrust.Access.Applications.Policies.Update
- DeleteAccessPolicy -> ZeroTrust.Access.Applications.Policies.Delete
- CreateSSL -> CustomCertificates.New
- ListSSL -> CustomCertificates.List
- SSLDetails -> CustomCertificates.Get
- UpdateSSL -> CustomCertificates.Update
- ReprioritizeSSL -> CustomCertificates.Prioritize.Update
- DeleteSSL -> CustomCertificates.Delete
- GetCustomNameservers -> CustomNameservers.Get
- CreateCustomNameservers -> CustomNameservers.New
- DeleteCustomNameservers -> CustomNameservers.Delete
- ListDexTests -> ZeroTrust.Devices.DEXTests.List
- CreateDeviceDexTest -> ZeroTrust.Devices.DEXTests.New
- UpdateDeviceDexTest -> ZeroTrust.Devices.DEXTests.Update
- GetDeviceDexTest -> ZeroTrust.Devices.DEXTests.Get
- DeleteDexTest -> ZeroTrust.Devices.DEXTests.Delete
- AccessBookmarks -> ZeroTrust.Access.Bookmarks.List
- ZoneLevelAccessBookmarks -> ZeroTrust.Access.Bookmarks.List
- AccessBookmark -> ZeroTrust.Access.Bookmarks.Get
- ZoneLevelAccessBookmark -> ZeroTrust.Access.Bookmarks.Get
- CreateAccessBookmark -> ZeroTrust.Access.Bookmarks.New
- CreateZoneLevelAccessBookmark -> ZeroTrust.Access.Bookmarks.New
- UpdateAccessBookmark -> ZeroTrust.Access.Bookmarks.Update
- UpdateZoneLevelAccessBookmark -> ZeroTrust.Access.Bookmarks.Update
- DeleteAccessBookmark -> ZeroTrust.Access.Bookmarks.Delete
- DeleteZoneLevelAccessBookmark -> ZeroTrust.Access.Bookmarks.Delete
- CreateZoneLockdown -> Firewall.Lockdowns.New
- UpdateZoneLockdown -> Firewall.Lockdowns.Update
- DeleteZoneLockdown -> Firewall.Lockdowns.Delete
- ZoneLockdown -> Firewall.Lockdowns.Get
- ListZoneLockdowns -> Firewall.Lockdowns.List
- GetRegionalTieredCache -> Cache.RegionalTieredCache.Get
- UpdateRegionalTieredCache -> Cache.RegionalTieredCache.Edit
- CreateWorkerRoute -> Workers.Routes.New
- DeleteWorkerRoute -> Workers.Routes.Delete
- ListWorkerRoutes -> Workers.Routess.List
- GetWorkerRoute -> Workers.Routes.Get
- UpdateWorkerRoute -> Workers.Routes.Update
- CreateWaitingRoom -> WaitingRooms.New
- ListWaitingRooms -> WaitingRooms.List
- WaitingRoom -> WaitingRooms.Get
- ChangeWaitingRoom -> WaitingRooms.Edit
- UpdateWaitingRoom -> WaitingRooms.Update
- DeleteWaitingRoom -> WaitingRooms.Delete
- WaitingRoomStatus -> WaitingRooms.Status
- WaitingRoomPagePreview -> WaitingRooms.Page.Preview
- CreateWaitingRoomEvent -> WaitingRooms.Events.New
- ListWaitingRoomEvents -> WaitingRooms.Events.List
- WaitingRoomEvent -> WaitingRooms.Events.List
- WaitingRoomEventPreview -> WaitingRooms.Events.Preview
- ChangeWaitingRoomEvent -> WaitingRooms.Events.Edit
- UpdateWaitingRoomEvent -> WaitingRooms.Events.Update
- DeleteWaitingRoomEvent -> WaitingRooms.Events.Delete
- ListWaitingRoomRules -> WaitingRooms.Rules.List
- CreateWaitingRoomRule -> WaitingRooms.Rules.New
- ReplaceWaitingRoomRules -> WaitingRooms.Rules.Update
- UpdateWaitingRoomRule -> WaitingRooms.Rules.Edit
- DeleteWaitingRoomRule -> WaitingRooms.Rules.Delete
- GetWaitingRoomSettings -> WaitingRooms.Settings.Get
- PatchWaitingRoomSettings -> WaitingRooms.Settings.Edit
- UpdateWaitingRoomSettings -> WaitingRooms.Settings.Update
- ListAccessMutualTLSCertificates -> ZeroTrust.Access.Certificates.List
- GetAccessMutualTLSCertificate -> ZeroTrust.Access.Certificates.Get
- CreateAccessMutualTLSCertificate -> ZeroTrust.Access.Certificates.New
- UpdateAccessMutualTLSCertificate -> ZeroTrust.Access.Certificates.Update
- DeleteAccessMutualTLSCertificate -> ZeroTrust.Access.Certificates.Delete
- GetAccessMutualTLSHostnameSettings -> ZeroTrust.Access.Certificates.Settings.List
- UpdateAccessMutualTLSHostnameSettings -> ZeroTrust.Access.Certificates.Settings.Update
- FirewallRules -> Firewall.Rules.List
- FirewallRule -> Firewall.Rules.Get
- CreateFirewallRules -> Firewall.Rules.New
- UpdateFirewallRule -> Firewall.Rules.Update
- UpdateFirewallRules -> Firewall.Rules.Update
- DeleteFirewallRule -> Firewall.Rules.Delete
- DeleteFirewallRules -> Firewall.Rules.Delete
- ListImagesVariants -> Images.V1.Variants.List
- GetImagesVariant -> Images.V1.Variants.Get
- CreateImagesVariant -> Images.V1.Variants.New
- DeleteImagesVariant -> Images.V1.Variants.Delete
- UpdateImagesVariant -> Images.V1.Variants.Update
- TeamsLocations -> ZeroTrust.Gateway.Locations.List
- TeamsLocation -> ZeroTrust.Gateway.Locations.Get
- CreateTeamsLocation -> ZeroTrust.Gateway.Locations.New
- UpdateTeamsLocation -> ZeroTrust.Gateway.Locations.Update
- DeleteTeamsLocation -> ZeroTrust.Gateway.Locations.Delete
- GetDCVDelegation -> DCVDelegation.UUID.Get
- ListPrefixes -> Addressing.Prefixes.List
- GetPrefix -> Addressing.Prefixes.Get
- UpdatePrefixDescription -> Addressing.Prefixes.Update
- GetAdvertisementStatus -> Addressing.Prefixes.BGP.Statuses.Get
- UpdateAdvertisementStatus -> Addressing.Prefixes.BGP.Statuses.Edit
- ListAccountRoles -> Accounts.Roles.List
- GetAccountRole -> Accounts.Roles.Get
- GetUserAuditLogs -> User.AuditLogs.List
- ListObservatoryPages -> Speed.Pages.List
- ArgoTunnels -> ZeroTrust.Tunnels.List
- ArgoTunnel -> ZeroTrust.Tunnels.Get
- CreateArgoTunnel -> ZeroTrust.Tunnels.New
- DeleteArgoTunnel -> ZeroTrust.Tunnels.Delete
- CleanupArgoTunnelConnections -> ZeroTrust.Tunnels.Connections.Delete
- CreateLogpushJob -> Logpush.Jobs.New
- ListLogpushJobs -> Logpush.Jobs.List
- GetLogpushJob -> Logpush.Jobs.Get
- UpdateLogpushJob -> Logpush.Jobs.Update
- DeleteLogpushJob -> Logpush.Jobs.Delete
- ListLogpushJobsForDataset -> Logpush.Datasets.Jobs.Get
- GetLogpushFields -> Logpush.Datasets.Fields.Get
- GetLogpushOwnershipChallenge -> Logpush.Ownership.Get
- ValidateLogpushOwnershipChallenge -> Logpush.Ownership.Validate
- CheckLogpushDestinationExists -> Logpush.Validate.Destination
- ListAccessGroups -> ZeroTrust.Access.Groups.List
- GetAccessGroup -> ZeroTrust.Access.Groups.Get
- CreateAccessGroup -> ZeroTrust.Access.Groups.New
- UpdateAccessGroup -> ZeroTrust.Access.Groups.Update
- DeleteAccessGroup -> ZeroTrust.Access.Groups.Delete
- ListAccessCustomPages -> ZeroTrust.Access.CustomPages.List
- GetAccessCustomPage -> ZeroTrust.Access.CustomPages.Get
- CreateAccessCustomPage -> ZeroTrust.Access.CustomPages.New
- DeleteAccessCustomPage -> ZeroTrust.Access.CustomPages.Delete
- UpdateAccessCustomPage -> ZeroTrust.Access.CustomPages.Update
- GetAuditSSHSettings -> ZeroTrust.Gateway.AuditSSHSettings.Get
- UpdateAuditSSHSettings -> ZeroTrust.Gateway.AuditSSHSettings.Update
- ListIPAccessRules -> Firewall.AccessRules.List
- SpectrumApplications -> Spectrum.Apps.List
- SpectrumApplication -> Spectrum.Apps.Get
- CreateSpectrumApplication -> Spectrum.Apps.New
- UpdateSpectrumApplication -> Spectrum.Apps.Update
- DeleteSpectrumApplication -> Spectrum.Apps.Delete
- CreateLoadBalancerPool -> LoadBalancers.Pools.New
- ListLoadBalancerPools -> LoadBalancers.Poolss.List
- GetLoadBalancerPool -> LoadBalancers.Pools.Get
- DeleteLoadBalancerPool -> LoadBalancers.Pools.Delete
- UpdateLoadBalancerPool -> LoadBalancers.Pools.Update
- CreateLoadBalancerMonitor -> LoadBalancers.Monitors.New
- ListLoadBalancerMonitors -> LoadBalancers.Monitorss.List
- GetLoadBalancerMonitor -> LoadBalancers.Monitors.Get
- DeleteLoadBalancerMonitor -> LoadBalancers.Monitors.Delete
- UpdateLoadBalancerMonitor -> LoadBalancers.Monitors.Update
- CreateLoadBalancer -> LoadBalancers.New
- ListLoadBalancers -> LoadBalancerss.List
- GetLoadBalancer -> LoadBalancers.Get
- DeleteLoadBalancer -> LoadBalancers.Delete
- UpdateLoadBalancer -> LoadBalancers.Update
- GetLoadBalancerPoolHealth -> LoadBalancers.Pools.Health
- CreateWorkersKVNamespace -> KV.Namespaces.New
- ListWorkersKVNamespaces -> KV.Namespacess.List
- DeleteWorkersKVNamespace -> KV.Namespaces.Delete
- UpdateWorkersKVNamespace -> KV.Namespaces.Update
- WriteWorkersKVEntries -> KV.Namespaces.Bulk.Update
- DeleteWorkersKVEntries -> KV.Namespaces.Bulk.Delete
- WriteWorkersKVEntry -> KV.Namespaces.New
- ListTunnelVirtualNetworks -> ZeroTrust.Networks.VirtualNetworks.List
- CreateTunnelVirtualNetwork -> ZeroTrust.Networks.VirtualNetworks.New
- DeleteTunnelVirtualNetwork -> ZeroTrust.Networks.VirtualNetworks.Delete
- UpdateTunnelVirtualNetwork -> ZeroTrust.Networks.VirtualNetworks.Update
- ListAccessTags -> ZeroTrust.Access.Tags.List
- GetAccessTag -> ZeroTrust.Access.Tags.Get
- CreateAccessTag -> ZeroTrust.Access.Tags.New
- DeleteAccessTag -> ZeroTrust.Access.Tags.Delete
- ListPageShieldPolicies -> PageShield.Policies.List
- CreatePageShieldPolicy -> PageShield.Policies.New
- DeletePageShieldPolicy -> PageShield.Policies.Delete
- GetPageShieldPolicy -> PageShield.Policies.Get
- UpdatePageShieldPolicy -> PageShield.Policies.Update
- ListAccessServiceTokens -> ZeroTrust.Access.ServiceTokens.List
- CreateAccessServiceToken -> ZeroTrust.Access.ServiceTokens.New
- UpdateAccessServiceToken -> ZeroTrust.Access.ServiceTokens.Update
- DeleteAccessServiceToken -> ZeroTrust.Access.ServiceTokens.Delete
- RefreshAccessServiceToken -> ZeroTrust.Access.ServiceTokens.Refresh
- RotateAccessServiceToken -> ZeroTrust.Access.ServiceTokens.Rotate
- ListMagicTransitGRETunnels -> MagicTransit.GRETunnels.List
- GetMagicTransitGRETunnel -> MagicTransit.GRETunnels.Get
- CreateMagicTransitGRETunnels -> MagicTransit.GRETunnels.New
- UpdateMagicTransitGRETunnel -> MagicTransit.GRETunnels.Update
- DeleteMagicTransitGRETunnel -> MagicTransit.GRETunnels.Delete
- ListEmailRoutingRules -> EmailRouting.Routing.Rules.List
- CreateEmailRoutingRule -> EmailRouting.Routing.Rules.New
- GetEmailRoutingRule -> EmailRouting.Routing.Rules.Get
- UpdateEmailRoutingRule -> EmailRouting.Routing.Rules.Update
- DeleteEmailRoutingRule -> EmailRouting.Routing.Rules.Delete
- GetEmailRoutingCatchAllRule -> EmailRouting.Routing.Rules.CatchAlls.Get
- UpdateEmailRoutingCatchAllRule -> EmailRouting.Routing.Rules.CatchAlls.Update
- Healthchecks -> Healthchecks.List
- Healthcheck -> Healthchecks.Get
- CreateHealthcheck -> Healthchecks.New
- UpdateHealthcheck -> Healthchecks.Update
- DeleteHealthcheck -> Healthchecks.Delete
- CreateHealthcheckPreview -> Healthchecks.Previews.New
- HealthcheckPreview -> Healthchecks.Previews.Get
- DeleteHealthcheckPreview -> Healthchecks.Previews.Delete
- UploadImage -> Images.V1.New
- UpdateImage -> Images.V1.Update
- CreateImageDirectUploadURL -> Images.V2.DirectUploads.New
- ListImages -> Images.V1.List
- GetImage -> Images.V1.Get
- DeleteImage -> Images.V1.Delete
- GetImagesStats -> Images.V1.Stats.Get
- ArgoSmartRouting -> Argo.SmartRouting.Get
- UpdateArgoSmartRouting -> Argo.SmartRouting.Update
- ArgoTieredCaching -> Argo.TieredCaching.Get
- UpdateArgoTieredCaching -> Argo.TieredCaching.Edit
- UniversalSSLSettingDetails -> SSL.Universal.Settings.Get
- EditUniversalSSLSetting -> SSL.Universal.Settings.Edit
- UniversalSSLVerificationDetails -> SSL.Verification.Get
- UpdateUniversalSSLCertificatePackValidationMethod -> SSL.Verification.Edit
- GetTieredCache -> Cache.SmartTieredCache.Get
- SetTieredCache -> Cache.SmartTieredCache.Edit
- DeleteTieredCache -> Cache.SmartTieredCache.Delete
- ListAccessIdentityProviders -> ZeroTrust.IdentityProviders.List
- GetAccessIdentityProvider -> ZeroTrust.IdentityProviders.Get
- CreateAccessIdentityProvider -> ZeroTrust.IdentityProviders.New
- UpdateAccessIdentityProvider -> ZeroTrust.IdentityProviders.Update
- DeleteAccessIdentityProvider -> ZeroTrust.IdentityProviders.Delete
- ListPagesDeployments -> Pages.Projects.Deployments.List
- GetPagesDeploymentInfo -> Pages.Projects.Deployments.Get
- GetPagesDeploymentLogs -> Pages.Projects.Deployments.Logs.Get
- DeletePagesDeployment -> Pages.Projects.Deployments.Delete
- CreatePagesDeployment -> Pages.Projects.Deployments.New
- RetryPagesDeployment -> Pages.Projects.Deployments.Retry
- RollbackPagesDeployment -> Pages.Projects.Deployments.Rollback
- CreateZone -> Zones.New
- ZoneActivationCheck -> Zones.ActivationCheck.Trigger
- ListZones -> Zones.List
- ZoneDetails -> Zones.Get
- ZoneSetPaused -> Zones.Edit
- ZoneSetType -> Zones.Edit
- ZoneSetVanityNS -> Zones.Edit
- ZoneSetPlan -> Zones.Edit
- ZoneUpdatePlan -> Zones.Edit
- EditZone -> Zones.Edit
- DeleteZone -> Zones.Delete
- PurgeEverything -> Cache.Purge
- PurgeCache -> Cache.Purge
- AvailableZoneRatePlans -> AvailableRatePlans.Get
- AvailableZonePlans -> AvailablePlans.List
- ZoneSettings -> Zones.Settings.Get
- UpdateZoneSettings -> Zones.Settings.Update
- ZoneSSLSettings -> Zones.Settings.SSL.List
- UpdateZoneSSLSettings -> Zones.Settings.SSL.Edit
- FallbackOrigin -> CustomHostnames.FallbackOrigin.Get
- UpdateFallbackOrigin -> CustomHostnames.FallbackOrigin.Update
- GetZoneSetting -> Zones.Settings.Get
- UpdateZoneSetting -> Zones.Settings.Edit
- ZoneExport -> DNS.Records.Export
- ZoneDNSSECSetting -> DNSSEC.Get
- DeleteZoneDNSSEC -> DNSSEC.Delete
- UpdateZoneDNSSEC -> DNSSEC.Edit
- ListCertificatePacks -> SSL.CertificatePacks.List
- CertificatePack -> SSL.CertificatePacks.Get
- CreateCertificatePack -> SSL.CertificatePacks.New
- DeleteCertificatePack -> SSL.CertificatePacks.Delete
- Filter -> Filters.Get
- Filters -> Filters.List
- CreateFilters -> Filters.New
- UpdateFilter -> Filters.Update
- UpdateFilters -> Filters.Update
- DeleteFilter -> Filters.Delete
- DeleteFilters -> Filters.Delete
- ListDLPProfiles -> ZeroTrust.DLP.Profiles.List
- GetDLPProfile -> ZeroTrust.DLP.Profiles.Get
- CreateDLPProfiles -> ZeroTrust.DLP.Profiles.Custom.New
- DeleteDLPProfile -> ZeroTrust.DLP.Profiles.Custom.Delete
- UpdateDLPProfile -> ZeroTrust.DLP.Profiles.Custom.Update
- ListAddressMaps -> Addressing.AddressMaps.List
- CreateAddressMap -> Addressing.AddressMaps.New
- GetAddressMap -> Addressing.AddressMaps.Get
- UpdateAddressMap -> Addressing.AddressMaps.Update
- DeleteAddressMap -> Addressing.AddressMaps.Delete
- CreateKeylessSSL -> KeylessCertificates.New
- ListKeylessSSL -> KeylessCertificates.List
- KeylessSSL -> KeylessCertificates.Get
- UpdateKeylessSSL -> KeylessCertificates.Update
- DeleteKeylessSSL -> KeylessCertificates.Delete
- GetBotManagement -> BotManagement.Get
- UpdateBotManagement -> BotManagement.Update
- ZoneCacheVariants -> Cache.Variants.Get
- UpdateZoneCacheVariants -> Cache.Variants.Update
- DeleteZoneCacheVariants -> Cache.Variants.Delete
- ListPagesProjects -> Pages.Projects.List
- GetPagesProject -> Pages.Projects.Get
- CreatePagesProject -> Pages.Projects.New
- UpdatePagesProject -> Pages.Projects.Edit
- DeletePagesProject -> Pages.Projects.Delete
- UpdateAccessUserSeat -> ZeroTrust.Seats.Edit
- UpdateAccessUsersSeats -> ZeroTrust.Seats.Edit
- ListWAFOverrides -> Firewall.WAF.Overrides.List
- WAFOverride -> Firewall.WAF.Overrides.Get
- CreateWAFOverride -> Firewall.WAF.Overrides.New
- UpdateWAFOverride -> Firewall.WAF.Overrides.Update
- DeleteWAFOverride -> Firewall.WAF.Overrides.Delete
- EnableEmailRouting -> EmailRouting.Routing.Enable
- DisableEmailRouting -> EmailRouting.Routing.Disable
- GetEmailRoutingDNSSettings -> EmailRouting.Routing.DNS.Get
- GetPageShieldSettings -> PageShield.Get
- UpdatePageShieldSettings -> PageShield.Update
- CreatePageRule -> Pagerules.New
- ListPageRules -> Pagerules.List
- PageRule -> Pagerules.Get
- ChangePageRule -> Pagerules.Edit
- UpdatePageRule -> Pagerules.Update
- DeletePageRule -> Pagerules.Delete
- PerformTraceroute -> Diagnostics.Traceroutes.New
- AccountMembers -> Accounts.Members.List
- CreateAccountMember -> Accounts.Members.New
- DeleteAccountMember -> Accounts.Members.Delete
- UpdateAccountMember -> Accounts.Members.Update
- AccountMember -> Accounts.Members.Get
- GetCacheReserve -> Cache.CacheReserve.Get
- UpdateCacheReserve -> Cache.CacheReserve.Update
- ListDeviceManagedNetworks -> ZeroTrust.Devices.Networks.List
- CreateDeviceManagedNetwork -> ZeroTrust.Devices.Networks.New
- UpdateDeviceManagedNetwork -> ZeroTrust.Devices.Networks.Update
- GetDeviceManagedNetwork -> ZeroTrust.Devices.Networks.Get
- DeleteManagedNetworks -> ZeroTrust.Devices.Networks.Delete
- WorkersCreateSubdomain -> Workers.Subdomains.Update
- WorkersGetSubdomain -> Workers.Subdomains.Get
- ListMagicTransitStaticRoutes -> MagicTransit.Routes.List
- GetMagicTransitStaticRoute -> MagicTransit.Routes.Get
- CreateMagicTransitStaticRoute -> MagicTransit.Routes.New
- UpdateMagicTransitStaticRoute -> MagicTransit.Routes.Update
- DeleteMagicTransitStaticRoute -> MagicTransit.Routes.Delete
- ListTunnelRoutes -> ZeroTrust.Networks.Routes.List
- GetTunnelRouteForIP -> ZeroTrust.Networks.Routes.Get
- CreateTunnelRoute -> ZeroTrust.Networks.Routes.New
- DeleteTunnelRoute -> ZeroTrust.Networks.Routes.Delete
- UpdateTunnelRoute -> ZeroTrust.Networks.Routes.Update
- ListPerHostnameAuthenticatedOriginPullsCertificates -> OriginTLSClientAuth.Hostnames.Certificates.List
- UploadPerHostnameAuthenticatedOriginPullsCertificate -> OriginTLSClientAuth.Hostnames.Certificates.New
- GetPerHostnameAuthenticatedOriginPullsCertificate -> OriginTLSClientAuth.Hostnames.Certificates.Get
- DeletePerHostnameAuthenticatedOriginPullsCertificate -> OriginTLSClientAuth.Hostnames.Certificates.Delete
- ForceSecondaryDNSZoneAXFR -> SecondaryDNS.ForceAXFR
- ListWorkerCronTriggers -> Workers.Scripts.Schedules.Get
- UpdateWorkerCronTriggers -> Workers.Scripts.Schedules.Update
- GetAPIToken -> User.Tokens.Get
- APITokens -> User.Tokens.List
- CreateAPIToken -> User.Tokens.New
- UpdateAPIToken -> User.Tokens.Update
- VerifyAPIToken -> User.Tokens.Verify
- DeleteAPIToken -> User.Tokens.Delete
- ListAPITokensPermissionGroups -> User.Tokens.PermissionGroups.List
- TeamsProxyEndpoint -> ZeroTrust.Gateway.ProxyEndpoints.Get
- TeamsProxyEndpoints -> ZeroTrust.Gateway.ProxyEndpoints.List
- CreateTeamsProxyEndpoint -> ZeroTrust.Gateway.ProxyEndpoints.New
- UpdateTeamsProxyEndpoint -> ZeroTrust.Gateway.ProxyEndpoints.Update
- DeleteTeamsProxyEndpoint -> ZeroTrust.Gateway.ProxyEndpoints.Delete
- ListAccessApplications -> ZeroTrust.Access.Applications.List
- GetAccessApplication -> ZeroTrust.Access.Applications.Get
- CreateAccessApplication -> ZeroTrust.Access.Applications.New
- UpdateAccessApplication -> ZeroTrust.Access.Applications.Update
- DeleteAccessApplication -> ZeroTrust.Access.Applications.Delete
- RevokeAccessApplicationTokens -> ZeroTrust.Access.Applications.RevokeTokens
- TeamsRules -> ZeroTrust.Gateway.Rules.List
- TeamsRule -> ZeroTrust.Gateway.Rules.Get
- TeamsCreateRule -> ZeroTrust.Gateway.Rules.New
- TeamsUpdateRule -> ZeroTrust.Gateway.Rules.Update
- TeamsPatchRule -> ZeroTrust.Gateway.Rules.Edit
- TeamsDeleteRule -> ZeroTrust.Gateway.Rules.Delete
- ListTeamsLists -> ZeroTrust.Gateway.Lists.List
- GetTeamsList -> ZeroTrust.Gateway.Lists.Get
- ListTeamsListItems -> ZeroTrust.Gateway.Lists.Items.List
- CreateTeamsList -> ZeroTrust.Gateway.Lists.New
- UpdateTeamsList -> ZeroTrust.Gateway.Lists.Update
- PatchTeamsList -> ZeroTrust.Gateway.Lists.Edit
- DeleteTeamsList -> ZeroTrust.Gateway.Lists.Delete
- ListDLPDatasets -> ZeroTrust.DLP.Datasets.List
- GetDLPDataset -> ZeroTrust.DLP.Datasets.Get
- CreateDLPDataset -> ZeroTrust.DLP.Datasets.New
- DeleteDLPDataset -> ZeroTrust.DLP.Datasets.Delete
- UpdateDLPDataset -> ZeroTrust.DLP.Datasets.Update
- CreateDLPDatasetUpload -> ZeroTrust.DLP.Datasets.Upload.New
- GetSecondaryDNSTSIG -> SecondaryDNS.TSIGs.Get
- ListSecondaryDNSTSIGs -> SecondaryDNS.TSIGs.List
- CreateSecondaryDNSTSIG -> SecondaryDNS.TSIGs.New
- UpdateSecondaryDNSTSIG -> SecondaryDNS.TSIGs.Update
- DeleteSecondaryDNSTSIG -> SecondaryDNS.TSIGs.Delete
- UpdateDeviceClientCertificates -> Device.Client.Certificates.Update
- GetDeviceClientCertificates -> Device.Client.Certificates.Get
- CreateDeviceSettingsPolicy -> ZeroTrust.Devices.Policies.New
- UpdateDefaultDeviceSettingsPolicy -> ZeroTrust.Devices.Policies.DefaultPolicy.Update
- GetDefaultDeviceSettingsPolicy -> ZeroTrust.Devices.Policies.DefaultPolicy.Get
- UpdateDeviceSettingsPolicy -> ZeroTrust.Devices.Policies.Update
- DeleteDeviceSettingsPolicy -> ZeroTrust.Devices.Policies.Delete
- GetDeviceSettingsPolicy -> ZeroTrust.Devices.Policies.Get
- ListDeviceSettingsPolicies -> Device.Settings.Policies.List
- URLNormalizationSettings -> URLNormalization.Get
- UpdateURLNormalizationSettings -> URLNormalization.Update
- UpdateCustomHostnameSSL -> CustomHostnames.Update
- UpdateCustomHostname -> CustomHostnames.Update
- DeleteCustomHostname -> CustomHostnames.Delete
- CreateCustomHostname -> CustomHostnames.New
- CustomHostnames -> CustomHostnames.List
- CustomHostname -> CustomHostnames.Get
- UpdateCustomHostnameFallbackOrigin -> CustomHostnames.FallbackOrigin.Update
- DeleteCustomHostnameFallbackOrigin -> CustomHostnames.FallbackOrigin.Delete
- CustomHostnameFallbackOrigin -> CustomHostnames.FallbackOrigin.Get
- GetAccessOrganization -> ZeroTrust.Organizations.Get
- CreateAccessOrganization -> ZeroTrust.Organizations.New
- UpdateAccessOrganization -> ZeroTrust.Organizations.Update
- ListFallbackDomains -> ZeroTrust.Devices.Policies.FallbackDomains.List
- UpdateFallbackDomain -> ZeroTrust.Devices.Policies.FallbackDomains.Update
- ListTeamsDevices -> ZeroTrust.Devices.List
- RevokeTeamsDevices -> ZeroTrust.Devices.Revokes.New
- GetTeamsDeviceDetails -> ZeroTrust.Devices.Get
- ListTunnels -> ZeroTrust.Tunnels.List
- GetTunnel -> ZeroTrust.Tunnels.Get
- CreateTunnel -> ZeroTrust.Tunnels.New
- UpdateTunnel -> ZeroTrust.Tunnels.Update
- UpdateTunnelConfiguration -> ZeroTrust.Tunnels.Configurations.Update
- GetTunnelConfiguration -> ZeroTrust.Tunnels.Configurations.Get
- ListTunnelConnections -> ZeroTrust.Tunnels.Configurations.List
- DeleteTunnel -> ZeroTrust.Tunnels.Delete
- CleanupTunnelConnections -> ZeroTrust.Tunnels.Connections.Delete
- GetTunnelToken -> ZeroTrust.Tunnels.Token.Get
- ListQueues -> Queues.List
- CreateQueue -> Queues.New
- DeleteQueue -> Queues.Delete
- GetQueue -> Queues.Get
- UpdateQueue -> Queues.Update
- ListQueueConsumers -> Queues.Consumers.List
- CreateQueueConsumer -> Queues.Consumers.New
- DeleteQueueConsumer -> Queues.Consumers.Delete
- UpdateQueueConsumer -> Queues.Consumers.Update
- ListD1Databases -> D1.Database.List
- CreateD1Database -> D1.Database.New
- DeleteD1Database -> D1.Database.Delete
- GetD1Database -> D1.Database.Get
- QueryD1Database -> D1.Database.Query
- ListAccessUsers -> ZeroTrust.Access.Users.List
- GetAccessUserActiveSessions -> ZeroTrust.Access.Users.ActiveSessions.List
- GetAccessUserFailedLogins -> ZeroTrust.Access.Users.FailedLogins.List
- GetAccessUserLastSeenIdentity -> ZeroTrust.Access.Users.LastSeenIdentity.Get
- CreateUserAgentRule -> Firewall.UARules.New
- UpdateUserAgentRule -> Firewall.UARules.Update
- DeleteUserAgentRule -> Firewall.UARules.Delete
- UserAgentRule -> Firewall.UARules
- ListUserAgentRules -> Firewall.UARules.List
- ListIPAccessRules -> Firewall.AccessRules.List
- UserDetails -> User.Get
- UpdateUser -> User.Edit
- UserBillingProfile -> User.Billing.Profile.Get
- UserBillingHistory -> User.Billing.History.Get
- CreateTurnstileWidget -> Challenges.Widgets.New
- ListTurnstileWidgets -> Challenges.Widgets.List
- GetTurnstileWidget -> Challenges.Widgets.Get
- UpdateTurnstileWidget -> Challenges.Widgets.Update
- RotateTurnstileWidget -> Challenges.Widgets.RotateSecret
- DeleteTurnstileWidget -> Challenges.Widgets.Delete
- ListWorkersDomains -> Workers.Domains.List
- AttachWorkersDomain -> Workers.Domains.Update
- GetWorkersDomain -> Workers.Domains.Get
- DetachWorkersDomain -> Workers.Domains.Delete
- GetLogpullRetentionFlag -> Logs.Control.Retention.Flag.Get
- SetLogpullRetentionFlag -> Logs.Control.Retention.Flag.Set
- CreateRateLimit -> RateLimits.New
- ListRateLimits -> RateLimits.List
- ListAllRateLimits -> RateLimits.List
- RateLimit -> RateLimits.Get
- UpdateRateLimit -> RateLimits.Update
- DeleteRateLimit -> RateLimits.Delete
- GetPagesDomains -> Pages.Projects.Domains.List
- GetPagesDomain -> Pages.Projects.Domains.Get
- PagesPatchDomain -> Pages.Projects.Domains.Edit
- PagesAddDomain -> Pages.Projects.Domains.New
- PagesDeleteDomain -> Pages.Projects.Domains.Delete
- ListMTLSCertificates -> MTLSCertificates.List
- GetMTLSCertificate -> MTLSCertificates.Get
- ListMTLSCertificateAssociations -> MTLSCertificates.Associations.Get
- CreateMTLSCertificate -> MTLSCertificates.New
- DeleteMTLSCertificate -> MTLSCertificates.Delete
- CreateDNSRecord -> DNS.Records.New
- ListDNSRecords -> DNS.Records.List
- GetDNSRecord -> DNS.Records.Get
- UpdateDNSRecord -> DNS.Records.Update
- DeleteDNSRecord -> DNS.Records.Delete
- ExportDNSRecords -> DNS.Records.Export
- ImportDNSRecords -> DNS.Records.Import
- TeamsAccount -> ZeroTrust.Gateway.Get
- TeamsAccountConfiguration -> ZeroTrust.Gateway.Configurations.Get
- TeamsAccountDeviceConfiguration -> Teams.Account.Device.Configuration.Get
- TeamsAccountUpdateConfiguration -> ZeroTrust.Gateway.Configurations.Update
- TeamsAccountLoggingConfiguration -> ZeroTrust.Gateway.Configurations.Logging.Get
- TeamsAccountUpdateLoggingConfiguration -> ZeroTrust.Gateway.Configurations.Logging.Set
- ListUserAccessRules -> User.Firewall.AccessRules.List
- CreateUserAccessRule -> User.Firewall.AccessRules.New
- UserAccessRule -> User.Firewall.AccessRules.Get
- UpdateUserAccessRule -> User.Firewall.AccessRules.Update
- DeleteUserAccessRule -> User.Firewall.AccessRules.Delete
- ListZoneAccessRules -> Firewall.AccessRules.List
- CreateZoneAccessRule -> Firewall.AccessRules.New
- ZoneAccessRule -> Firewall.AccessRules.Get
- UpdateZoneAccessRule -> Firewall.AccessRules.Update
- DeleteZoneAccessRule -> Firewall.AccessRules.Delete
- ListAccountAccessRules -> Firewall.AccessRules.List
- CreateAccountAccessRule -> AFirewall.AccessRules.New
- AccountAccessRule -> Firewall.AccessRules.Rule.Get
- UpdateAccountAccessRule -> Firewall.AccessRules.Rule.Update
- DeleteAccountAccessRule -> Firewall.AccessRules.Rule.Delete
- ListWorkerBindings -> Workers.Scripts.Bindings.Get
- AccessKeysConfig -> ZeroTrust.Access.Keys.List
- UpdateAccessKeysConfig -> ZeroTrust.Access.Keys.Update
- RotateAccessKeys -> ZeroTrust.Access.Keys.Rotate
- ListLists -> Rules.Lists.List
- CreateList -> Rules.Lists.New
- GetList -> Rules.Lists.Get
- UpdateList -> Rules.Lists.Update
- DeleteList -> Rules.Lists.Delete
- ListListItems -> Rules.ListsItems.List
- CreateListItem -> Rules.Lists.Items.New
- CreateListItems -> Rules.Lists.Items.New
- ReplaceListItems -> Rules.Lists.Items.Update
- DeleteListItems -> Rules.Lists.Items.Delete
- GetListItem -> Rules.Lists.Items.Get
- GetListBulkOperation -> Rules.Lists.BulkOperations.Get
- ListWAFPackages -> Firewall.WAF.Packages.List
- WAFPackage -> Firewall.WAF.Packages.Get
- UpdateWAFPackage -> Firewall.WAF.Packages.Update
- ListWAFGroups -> Firewall.WAF.Groups.List
- WAFGroup -> Firewall.WAF.Groups.Get
- UpdateWAFGroup -> Firewall.WAF.Groups.Update
- ListWAFRules -> Firewall.WAF.Packages.Rules.List
- WAFRule -> Firewall.WAF.Packages.Rules
- UpdateWAFRule -> Firewall.WAF.Packages.Rules.Update
- ListRulesets -> Rulesets.List
- GetRuleset -> Rulesets.Get
- CreateRuleset -> Rulesets.New
- DeleteRuleset -> Rulesets.Delete
- UpdateRuleset -> Rulesets.Update
- Accounts -> Accounts.List
- Account -> Accounts.Get
- UpdateAccount -> Accounts.Update
- CreateAccount -> Accounts.New
- DeleteAccount -> Accounts.Delete
- CreateOriginCACertificate -> OriginCACertificates.New
- ListOriginCACertificates -> OriginCACertificates.List
- GetOriginCACertificate -> OriginCACertificates.Get
- RevokeOriginCACertificate -> OriginCACertificates.Delete
- CreateDNSFirewallCluster -> DNS.Firewall.New
- GetDNSFirewallCluster -> DNS.Firewall.Get
- ListDNSFirewallClusters -> DNS.Firewall.List
- UpdateDNSFirewallCluster -> DNS.Firewall.Update
- DeleteDNSFirewallCluster -> DNS.Firewall.Delete
- GetDNSFirewallUserAnalytics -> DNS.Firewall.Analytics.Reports.Get
- ListHostnameTLSSettings -> OriginTLSClientAuth.Settings.Get
- UpdateHostnameTLSSetting -> OriginTLSClientAuth.Settings.Update
- ListHostnameTLSSettingsCiphers -> Hostname.TLSSettings.Ciphers.List
- UpdateHostnameTLSSettingCiphers -> Hostname.TLSSetting.Ciphers.Update
- DeleteHostnameTLSSettingCiphers -> Hostname.TLSSetting.Ciphers.Delete
