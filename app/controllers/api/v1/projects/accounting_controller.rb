module Api
  module V1
    module Projects
      class AccountingController < ApplicationController
        def complete
          result = ::Projects::Accounting::Actions::Complete.new.call(
            project_api_id: params[:api_id]
          )

          case result
          when Results::Success
            render json: { project: result.value!.as_json }, status: :ok
          when Results::Failure
            render json: { error: result.failure }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
