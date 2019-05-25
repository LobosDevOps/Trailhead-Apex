1. Data Integration Specialist -- superbadge
https://trailhead.salesforce.com/ja/content/learn/superbadges/superbadge_integration
※ Trailheadスーパーバッジにチャレンジしよう vol3. – Data Integration Specialist のTipsと日本語訳
https://developer.salesforce.com/jpblogs/2018/06/data_integration_superbadge/

  1) step1: Configure outbound application and integration security  -- outlined
       A.  Configure a named credential(指定ログイン情報)  -- REST-based
        ・表示ラベル: ProjectService
        ・URL:       https://sb-integration-pms.herokuapp.com/projects
        ・証明書:    null
        ・ID 種別:   指定ユーザー
        ・認証プロトコル: password
        ・ユーザ名:     pmsUser1
        ・pwd:         xxx
        ・認証ヘッダーを生成:  check
        ・HTTP ヘッダーの差し込み項目を許可:  uncheck
        ・HTTP 本文の差し込み項目を許可:      uncheck
        . other
          Additional Project Management System API Details
          ・HTTP Method:       post
          ・Required Headers:  Content-Type: JSON
          ・Return Status:     ‘OK’ or error message
          ・Response Code:     201 = Success 500 = Failure
      B. Configure a remote site (リモートサイトの設定)　 -- SOAP-based
        ・リモートサイト名:               BillingService
        ・リモートサイトの URL:           http://sb-integration-bs.herokuapp.com
        ・プロトコルセキュリティの無効化:  uncheck
        ・有効:                          check
        ・other                          Return Status:	'OK' 'UNAUTHORIZED'
      C. Configure a custom setting (unpkg　に既に作成済み)   -- for remote site [BillingService]
        ・表示ラベル:    ServiceCredentials
        ・表示:          保護
        ・設定種別:      リスト
        ・カスタム項目: 	Password  Username
        ・manamge data:  name :     BillingServiceCredential
                         Username:  bsUser1
                         Password:  xxx
  2) step2: Configure inbound integration security   -- inbound  -- for PMS Connected
       A.  Configure a custom setting (unpkg　に既に作成済み)
        ・表示ラベル:    ServiceTokens
        ・表示:          保護
        ・設定種別:      リスト
        ・カスタム項目: 	 Token
        ・manamge data:  name :     ProjectServiceToken
                         Username:  xxxxx  (Remote site から取得する)
       B. Connected Apps (App manager - new Connected App )
         ※ The external PMS service calls your org’s custom Apex REST service back
         ※　作成しなくても、StepCheckが通過できる
        ・接続アプリケーション名:    ProjectService
        ・取引先責任者 メール:       your mail
        ・OAuth 設定の有効化:       check
        ・コールバック URL:         https://sb-integration-pms.herokuapp.com/oauth/_callback
        ・選択した OAuth 範囲:      Full access 
                                   Perform requests on your behalf at any time (refresh_token, offline_access)      
  3) Synchronize Salesforce opportunity data with Square Peg's PMS external system
