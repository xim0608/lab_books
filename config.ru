# This file is used by Rack-based servers to start the application.
require 'unicorn/worker_killer'

use Unicorn::WorkerKiller::MaxRequests, 100, 120, true
require_relative 'config/environment'

run Rails.application
