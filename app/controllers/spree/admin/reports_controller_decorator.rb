Spree::Admin::ReportsController.class_eval do
   before_action :add_products_run_out_reports, only: [:index]
      def add_products_run_out_reports
        Spree::Admin::ReportsController.add_available_report! :products_ran_out_of_stock
      end
  
      def products_ran_out_of_stock
        params[:q] = {} unless params[:q]

        if params[:q][:updated_at_gt].blank?
          params[:q][:updated_at_gt] = Time.zone.now.beginning_of_month
        else
          params[:q][:updated_at_gt] = Time.zone.parse(params[:q][:updated_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
        end

        if params[:q] && !params[:q][:updated_at_lt].blank?
          params[:q][:updated_at_lt] = Time.zone.parse(params[:q][:updated_at_lt]).end_of_day rescue ""
        end

        params[:q][:s] ||= "updated_at desc"

        # ransack don't work well with includes/join
        
        @search = Spree::Variant.active.out_of_stock.ransack(params[:q])
        @variants = @search.result(distinct: true).page(params[:page]).per(Spree::Config[:admin_products_per_page])
      end

end
