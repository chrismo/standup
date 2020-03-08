# frozen_string_literal: true

Rails.application.config.session_store :cookie_store,
                                       key: "_p_session_id",
                                       expire_after: 10.years
