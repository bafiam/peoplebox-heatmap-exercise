class HeatmapController < ApplicationController
  def index
    # extract all driver caterogries and dpts -uniq
    @drivers = [].to_set
    @dpts = [].to_set
    Response.find_each do |res|
      @drivers.add(res.driver_name)
    end
    Employee.find_each do |res|
      @dpts.add(res.department)
    end


    render json: @dpts
  end
end
