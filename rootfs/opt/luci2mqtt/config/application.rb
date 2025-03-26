# frozen_string_literal: true

require_relative 'environment'

result = LoadAll.result
exit(1) unless result.success?

router = result.router

router.discover_all
router.publish_all
