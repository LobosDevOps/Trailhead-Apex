1. Data Integration Specialist -- superbadge
https://trailhead.salesforce.com/ja/content/learn/superbadges/superbadge_integration
  1) step1: Configure outbound application and integration security  -- outlined
       A.  Configure a named credential(指定ログイン情報)
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
      B. Configure a remote site (リモートサイトの設定)
        ・リモートサイト名:               BillingService
        ・リモートサイトの URL:           http://sb-integration-bs.herokuapp.com
        ・プロトコルセキュリティの無効化:  uncheck
        ・有効:                          check
      C. Configure a custom setting (unpkg　に既に作成済み)
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
       
  3) Synchronize Salesforce opportunity data with Square Peg's PMS external system
