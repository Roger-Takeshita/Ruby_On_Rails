class PortfoliosController < ApplicationController
  def index
    @portfolio_items = Portfolio.all
  end

  def new
    @portfolio_item = Portfolio.new
  end

  def create
    @portfolio_item = Portfolio.create(params.require(:portfolio).permit(
                                         :title, :subtitle, :body
                                       ))

    respond_to do |format|
      if @portfolio_item.save
        format.html {
          redirect_to portfolios_path, notice: 'Your portfolio has been created'
        }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    @portfolio_item = Portfolio.find(params[:id])
  end

  def update
    @portfolio_item = Portfolio.find(params[:id])
    respond_to do |format|
      if @portfolio_item.update(params.require(:portfolio).permit(
                                  :title,
                                  :subtitle,
                                  :body
                                ))

        format.html {
          redirect_to portfolios_path, notice: 'Your portfolio has updated'
        }
      end
    end
  end

  def show
    @portfolio_item = Portfolio.find(params[:id])
  end

  def destroy
    # Perform lookup
    @portfolio_item = Portfolio.find(params[:id])

    # Destroy/delete the record
    @portfolio_item.destroy

    # Redirect
    respond_to do |format|
      format.html {
        redirect_to portfolios_url, notice: 'Your portfolio has been deleted'
      }
    end
  end
end
