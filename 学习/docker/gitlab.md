/etc/gitlab/gitlab.rb 包含了基本所有配置

进入admin用户，setting -> general -> account and limit 可以禁用gravatar



```yaml
---
kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: gitlab
  name: gitlab
  namespace: default
spec:
  type: NodePort
  ports:
    - port: 80
      name: http
      targetPort: 80
      nodePort: 30018
    - port: 22
      name: shell
      targetPort: 22
      nodePort: 30022
  selector:
    k8s-app: gitlab
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: gitlab-config
  namespace: default
  labels:
    k8s-app: gitlab
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  volumeMode: Filesystem
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: gitlab-log
  namespace: default
  labels:
    k8s-app: gitlab
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 300Mi
  volumeMode: Filesystem
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: gitlab-data
  namespace: default
  labels:
    k8s-app: gitlab
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  volumeMode: Filesystem

---
kind: ConfigMap
apiVersion: v1
metadata:
  name: gitlab-env
  namespace: default
  labels:
    k8s-app: gitlab
data:
  GITLAB_OMNIBUS_CONFIG: |
    external_url 'http://192.168.202.159:30018/'
    nginx['listen_port'] = 80
    gitlab_rails['gitlab_ssh_host'] = '192.168.202.159:30022'
    gitlab_rails['gitlab_shell_git_timeout'] = 1800
    gitlab_rails['smtp_enable'] = true
    gitlab_rails['smtp_address'] = "mail.sczq.com.cn"
    gitlab_rails['smtp_port'] = 25
    gitlab_rails['smtp_user_name'] = "niusiyuansc@sczq.com.cn"
    gitlab_rails['smtp_password'] = "niuSiyuan1992"
    gitlab_rails['gitlab_email_enabled'] = true
    gitlab_rails['gitlab_email_from'] = 'niusiyusnc@sczq.com.cn'
    gitlab_rails['gitlab_email_display_name'] = 'GitLab'
    gitlab_rails['initial_root_password'] = 'gitlab123!'
    gitlab_rails['ldap_enabled'] = true
    gitlab_rails['prevent_ldap_sign_in'] = false
    gitlab_rails['ldap_servers'] = YAML.load <<-'EOS'
      main: 
        label: 'LDAP'
        host: '192.168.1.14'
        port: 389
        uid: 'sAMAccountName'
        bind_dn: 'CN=牛思源,OU=信息技术部,OU=总部,OU=首创证券,DC=sc,DC=local'
        password: 'niuSiyuan1992'
        encryption: 'plain'
        verify_certificates: false
        smartcard_auth: false
        active_directory: true
        allow_username_or_email_login: true
        lowercase_usernames: true
        block_auto_created_users: false
        base: 'OU=首创证券,DC=sc,DC=local'
        user_filter: ''
    EOS
---
kind: Deployment
apiVersion: apps/v1
metadata:
  labels:
    k8s-app: gitlab
  name: gitlab
  namespace: default
spec:
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      k8s-app: gitlab
  template:
    metadata:
      labels:
        k8s-app: gitlab
    spec:
      containers:
        - name: gitlab
          image: "gitlab/gitlab-ce:14.1.2-ce.0"
          imagePullPolicy: Always
          ports:
            - containerPort: 80
              protocol: TCP
            - containerPort: 22
              protocol: TCP
          envFrom:
            - configMapRef:
                name: gitlab-env 
          volumeMounts:
            - name: gitlab-config
              mountPath: /etc/gitlab
            - name: gitlab-log
              mountPath: /var/log/gitlab
            - name: gitlab-data
              mountPath: /var/opt/gitlab
          
      volumes:
        - name: gitlab-config
          persistentVolumeClaim:
            claimName: gitlab-config
        - name: gitlab-log
          persistentVolumeClaim:
            claimName: gitlab-log
        - name: gitlab-data
          persistentVolumeClaim:
            claimName: gitlab-data



```

