workspace {

    model {
        held_admin = person "HELD Admin" "Authenticated user with administrator privileges of the HELD Application" "HELD_Persons"
        held_member = person "HELD Member" "Authenticated user of the HELD Application with no club membership"  "HELD_Persons"
        club_admin = person "Club Admin" "User with administrator privileges of at least one club" "HELD_Persons"
        club_member = person "Club Member" "Authenticated user with membership to at least one club" "HELD_Persons"
        unknown = person "Unknown" "Unauthenticated user"  "HELD_Persons"
        authenticated_users = person "Authenticated Users" "HELD Admin, HELD Member, Club Admin, Club Member" "Grouped_Actor"
        everyone = person "Everyone" "HELD Admin, HELD Member, Club Admin, Club Member, Unknown" "Grouped_Actor"

        group "Cloud Environment" {
            held_application = softwareSystem "HELD" "Heldenhelfer Applications" "HELD_Core_System" {
                hero_portal_web_ui = container "Hero Portal Web UI" "Singlepage Application" "Next.js" "HELD_Components" {
                    hero_portal_web_ui_server = component "Web UI" "Server component"
                }
                hero_portal_backend = container "Hero Portal Backend" "Backend Microservice" "FastAPI" "HELD_Components" {
                    hero_portal_backend_clubs = component "Clubs" "Administration component of the clubs"
                }
                identity_provider_sidecar_backend = container "Identity Provider Sidecar Backend" "Backend Microservice for identity provider configuration" "FastAPI" "HELD_Components" {
                    kc_configure_service = component "Keycloak Configure Service" "Configuration component for keycloak"
                    kc_query_service = component "Keycloak Query Service" "Query component to get keycloak information"
                }
                club_forum = container "Club Forum" "Community Portal based on Open Source Software 'Discourse'" "Discourse" "HELD_Components"  {
                    club_forum_sidecar = component "Club Forum Sidecar" "Sidecar service for discourse configuration"
                    club_forum_main = component "Discourse" "Main Discourse installation"
                    club_forum_cakeday = component "Cakeday" "Discourse Plug-In"
                    club_forum_solved = component "Solved" "Discourse Plug-In"
                    club_forum_yearly_review = component "Yearly Review" "Discourse Plug-In"
                    club_forum_checklist = component "Checklist" "Discourse Plug-In"
                    club_forum_docs = component "Docs" "Discourse Plug-In"
                    club_forum_oauth = component "OAuth 2.0 & OpenID Connect Support" "Discourse Plug-In"
                    club_forum_topic_voting = component "Topic Voting" "Discourse Plug-In"
                    club_forum_assign = component "Assign" "Discourse Plug-In"
                    club_forum_footnote = component "Footnote" "Discourse Plug-In"
                    club_forum_spoiler_alert = component "Spoiler Alert" "Discourse Plug-In"
                    club_forum_templates = component "Templates" "Discourse Plug-In"
                    club_forum_redis_master = component "Club Froum Resdis Master" "Real Time Data Platform" 
                    club_forum_redis_replica = component "Club Froum Resdis Replica" "Real Time Data Platform"
                }
                digital_office = container "Digital Office" "Digital Office based on Open Source Software 'Nextcloud'" "Nextcloud" "HELD_Components" {
                    digital_office_sidecar = component "Digital Office Sidecar" "Sidecar service for nextcloud configuration"
                    digital_office_main = component "Nextcloud" "Main Nextcloud installation"
                    digital_office_office = component "Nextcloud Office" "Nextcloud Office App"
                    digital_office_oidc = component "OpenID Connect Login" "Nextcloud OIDC App"
                    digital_office_collabora = component "Collabora" "Collabora Service"
                }
            }   
            sch_application = softwareSystem "SCH" "Smart City Hub Applications" "SCH_Core_System"{
                data_market_web_ui = container "Data Market Web UI"
                data_market_backend = container "Data Market Backend"
            }
            identity_provider = softwareSystem "IAM" "Identity- and Accessmanagement" "Core_System" {
                sch_realm = container "SCH Realm" {
                    hero_portal_application = component "Hero Portal Application" "Keycloak client"
                    digital_office_application = component "Digital Office Application" "Keycloak Client"
                    club_forum_application = component "Club Forum Application" "Keycloak Client"
                }
            }
            monitoring = softwareSystem "Monitoring" "Monitoring and Logging"  "Core_System"
            database_server = softwareSystem "Database Server" "PostgreSQL Server" "TAG_Data_Storage"{
                sch_databases = container "SCH Databases" "Databases of the Smart City Hub" "PostgreSQL" "TAG_Data_Storage"
                hero_portal_database = container "Hero Portal Database" "" "PostgreSQL" "TAG_Data_Storage" {
                    clubs_schema = component "Clubs" "Clubs database schema"
                }
                digital_office_database = container "Digital Office Database" "Nextcloud DB" "PostgreSQL" "TAG_Data_Storage" {
                    digital_office_public_schema = component "Public" "Public database schema"
                }
                club_forum_database = container "Discourse Database" "" "PostgreSQL" "TAG_Data_Storage" {
                    club_forum_public_schema = component "Public" "Public database schema"
                }
            }
            event_streaming = softwareSystem "Event Streaming" "Distributed Message Service (Kafka)" "Message_System"
            file_store = softwareSystem "File System" "Scalable File Service"  "TAG_Data_Storage" {
                sch_file_directory = container "SCH File Directory" "Directory of the Smart City Hub" "SFS" "TAG_Data_Storage"
                hero_portal_file_directory = container "Hero Portal Directory" "Directory of Hero Portal" "SFS" "TAG_Data_Storage"
            }
            evs_persistent_volume = softwareSystem "EVS" "Elastic Volume Service" "TAG_Data_Storage" {
                digital_office_nextcloud = container "Digital Office Persistence" "" "" "TAG_Data_Storage"
                digital_office_nextcloud_data = container "Digital Office Data Persistence" "" "" "TAG_Data_Storage"
                club_forum_redis_master_data = container "Club Forum Redis Master Persistence" "" "" "TAG_Data_Storage"
                club_forum_redis_replica_data = container "Club Forum Redis Replica Persistence" "" "" "TAG_Data_Storage"
                club_forum_persistence = container "Club Forum Data Persistence" "" "" "TAG_Data_Storage"
            }
        }
        browser = softwareSystem "Internet Browser" "Chrome, Firefox, Edge, ..." "Client_System"

        # actors
        held_admin -> held_application "Uses"

        held_member -> held_application "Uses"

        club_admin -> held_application "Uses"

        club_member -> held_application "Uses"

        unknown -> held_application "Uses"

        authenticated_users -> hero_portal_web_ui "Uses"
        authenticated_users -> digital_office "Uses"
        authenticated_users -> club_forum "Uses"

        everyone -> hero_portal_web_ui "Uses"
        
        # containers
        held_application -> identity_provider "Single Sign On"

        browser -> hero_portal_web_ui "Uses"
        browser -> digital_office "Uses"
        browser -> club_forum "Uses"

        identity_provider_sidecar_backend -> identity_provider "Read and change configuration/information" "REST API"

        # components
        hero_portal_web_ui_server -> hero_portal_backend_clubs "Clubs Administration" "REST API"
        hero_portal_web_ui_server -> hero_portal_application "Get Access Tokens" "REST API" "TAG_hero_portal_web_ui_to_iam_relationship"

        hero_portal_backend_clubs -> clubs_schema "Clubs data persistence" "SQL"
        hero_portal_backend_clubs -> hero_portal_file_directory "Stores Files" "CSI"
        hero_portal_backend_clubs -> event_streaming "Publish Club Events"
        hero_portal_backend_clubs -> kc_query_service "Get user information" "REST API"

        kc_configure_service -> digital_office_application "Create and Assign group roles"
        
        digital_office_sidecar -> digital_office_main "Digital Office area configuration" "REST API"
        digital_office_sidecar -> kc_configure_service "Create and Assign group roles" "REST API" "TAG_digital_office_to_event_streaming_relationship"
        digital_office_sidecar -> event_streaming "Subscribe Club Events" "" "TAG_digital_office_to_event_streaming_relationship"

        digital_office_main -> digital_office_public_schema "Digital Office data persistence" "SQL" "TAG_digital_office_to_postgres_relationship"
        digital_office_main -> digital_office_office "Uses Installed App"
        digital_office_main -> digital_office_oidc "Uses Installed App"
        digital_office_main -> digital_office_nextcloud "Pesists data" "CSI"
        digital_office_main -> digital_office_nextcloud_data "Pesists data" "CSI"

        digital_office_oidc -> digital_office_application "Authenticates/Authorizes User" "OpenID Connect" "TAG_digital_office_to_iam_relationship"

        digital_office_office -> digital_office_collabora "Uses Server"

        club_forum_sidecar -> club_forum_main "Club Forum area configuration" "REST API"
        club_forum_sidecar -> event_streaming "Subscribe Club Events" "" "TAG_club_forum_to_event_streaming_relationship"

        club_forum_main -> club_forum_public_schema "Club Forum data persistence" "SQL" "TAG_club_forum_to_postgres_relationship"
        club_forum_main -> club_forum_persistence "Persists data" "CSI" "TAG_club_forum_to_pvc_relationship"
        club_forum_main -> club_forum_redis_master "Persists data" "" "TAG_club_forum_to_redis_relationship"
        club_forum_main -> club_forum_cakeday "Use Plug-In"
        club_forum_main -> club_forum_solved "Use Plug-In"
        club_forum_main -> club_forum_yearly_review "Use Plug-In"
        club_forum_main -> club_forum_checklist "Use Plug-In"
        club_forum_main -> club_forum_docs "Use Plug-In"
        club_forum_main -> club_forum_oauth "Use Plug-In"
        club_forum_main -> club_forum_topic_voting "Use Plug-In"
        club_forum_main -> club_forum_assign "Use Plug-In"
        club_forum_main -> club_forum_footnote "Use Plug-In"
        club_forum_main -> club_forum_spoiler_alert "Use Plug-In"
        club_forum_main -> club_forum_templates "Use Plug-In"

        club_forum_oauth -> club_forum_application "Authenticates/Authorizes User" "OpenID Connect" "TAG_club_forum_to_iam_relationship"

        club_forum_redis_master -> club_forum_redis_replica "Synchronises data"
        club_forum_redis_master -> club_forum_redis_master_data "Persists data"

        club_forum_redis_replica -> club_forum_redis_replica_data "Persists data"

        sch_deployment = deploymentEnvironment "Development" {
            otc = deploymentNode "Open Telekom Cloud"{
                cce = deploymentNode "CCE" "" "Kubernetes Cluster" "TAG_Deployment_CCE"{
                    app_namespace = deploymentNode "app" "" "Kubernetes Namespace"{
                        softwareSystemInstance sch_application
                        softwareSystemInstance identity_provider
                    }
                    monitoring_namespace = deploymentNode "monitoring" "" "Kubernetes Namespace" {
                        softwareSystemInstance monitoring
                    }
                    hero_namespace = deploymentNode "hero" "" "Kubernetes Namespace" {
                        containerInstance hero_portal_backend
                        containerInstance hero_portal_web_ui
                        containerInstance digital_office
                        containerInstance club_forum
                        containerInstance identity_provider_sidecar_backend
                    }
                }
                rds = deploymentNode "RDS" "" "Database Server" "TAG_Deployment_RDS"{
                    containerInstance sch_databases
                    containerInstance hero_portal_database
                    containerInstance digital_office_database
                    containerInstance club_forum_database
                }
                dms = deploymentNode "DMS" "" "Distributed Database Service" "TAG_Deployment_DMS"{
                    softwareSystemInstance event_streaming
                }
                sfs = deploymentNode "SFS" "" "Scalable File Service" "TAG_Deployment_SFS"{
                    containerInstance sch_file_directory
                    containerInstance hero_portal_file_directory
                }
                evs = deploymentNode "EVS" "" "Elastic Volume Service" "TAG_Deployment_EVS" {
                    containerInstance digital_office_nextcloud
                    containerInstance digital_office_nextcloud_data
                    containerInstance club_forum_redis_master_data
                    containerInstance club_forum_redis_replica_data
                    containerInstance club_forum_persistence
                }
            }
            client = deploymentNode "Client Device" "" "Client browser (Mobile, PC, ...)" "TAG_Deployment_client"{
                softwareSystemInstance browser
            }
        }

        
    }

    views {
        systemlandscape "SystemLandscape" {
            include element.tag==HELD_Core_System
            include element.tag==SCH_Core_System
            include element.tag==Core_System
            include element.tag==HELD_Persons
        }
        systemContext held_application {
            include *
            exclude element.tag==Client_System
            exclude element.tag==Grouped_Actor
        }

        container held_application {
            include *
            exclude element.tag==Client_System
        }

        component hero_portal_backend {
            include *
            exclude relationship.tag==TAG_digital_office_to_iam_relationship
            exclude relationship.tag==TAG_digital_office_to_postgres_relationship
            exclude relationship.tag==TAG_hero_portal_web_ui_to_iam_relationship
            exclude relationship.tag==TAG_club_forum_to_iam_relationship
            exclude relationship.tag==TAG_club_forum_to_pvc_relationship
            exclude relationship.tag==TAG_club_forum_to_postgres_relationship
            exclude relationship.tag==TAG_club_forum_to_event_streaming_relationship
            exclude relationship.tag==TAG_digital_office_to_event_streaming_relationship
        }

        component digital_office {
            include *
        }

        component club_forum {
            include *
        }

        component sch_realm {
            include *
        }

        deployment * sch_deployment {
            include element.tag==TAG_Deployment_CCE
            include element.tag==TAG_Deployment_DMS
            include element.tag==TAG_Deployment_RDS
            include element.tag==TAG_Deployment_SFS
            include element.tag==TAG_Deployment_EVS
            include element.tag==TAG_Deployment_client
            include element.tag==TAG_Deployment_OBS
        }

        styles {
            element "HELD_Core_System" {
                background #00802b
                color #ffffff
                shape RoundedBox
                opacity 80
            }
            element "HELD_Components" {
                background #00802b
                color #ffffff
                shape RoundedBox
                opacity 60
            }
            element "TAG_Data_Storage" {
                background #ff3385
                color #ffffff
                shape Cylinder
                opacity 60
            }
            element "Message_System" {
                background #ff3385
                color #ffffff
                shape Pipe
                opacity 60
            }
        }
        theme default
    }

}