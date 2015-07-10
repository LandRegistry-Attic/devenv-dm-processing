class { '::rabbitmq':
  service_manage    => true,
  port              => '5672',
  package_source    => 'https://github.com/rabbitmq/rabbitmq-server/releases/download/rabbitmq_v3_4_4/rabbitmq-server-3.4.4-1.noarch.rpm'
}
