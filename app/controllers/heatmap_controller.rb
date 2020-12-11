# frozen_string_literal: true

class HeatmapController < ApplicationController
  def index
    # extract all driver caterogries and dpts -uniq
    @drivers = [].to_set
    @dpts = [].to_set
    Response.find_each do |res|
      @drivers.add(res.driver_name)
      @dpts.add(res.employee.department)
    end
    # classify all the responses based on the dept and driver
    results = []
    @resp = Hash.new('')
    @response = Hash.new([])
    @drivers.each do |drv|
      Response.find_each do |res|
        if res.driver_name == drv
          @dpts.each do |dp|
            @response[dp] += [res.score.to_i] if res.employee.department == dp
          end

        end
      end
    end
    # compute the avarage for each dept rounded to the nearest 3 decimals
    # return data based on the driver
    @drivers.each do |i|
      hash = {}
      hash['driver'] = i
      hash['score'] = {}
      @response.each do |key, value|
        # can use inject for accum or reduce(:+)
        # set float default instead of to_f
        hash['score'][key] = (value.inject(0.0) { |sum, el| sum + el } / value.size).round(3)
      end
      results << hash
    end

    render json: results
  end
end
