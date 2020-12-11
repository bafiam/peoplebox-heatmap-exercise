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
    results = []
    @resp = Hash.new("")
    @response = Hash.new([])
    @drivers.each do |drv|
      Response.find_each do |res|
        if res.driver_name == drv
          getEmp = Employee.find(res.employee_id)
          @dpts.each do |dp|
            if getEmp.department == dp
              @response[dp] += [res.score.to_i]
             
          end
          end
          
        end
        
      
      end
    end
    @drivers.each do |i|
      hash = {}
      hash["driver"] = i
      hash["score"] = {}
      @response.each do |key, value| 
       
        hash["score"][key] = (value.inject(0.0) { |sum, el| sum + el } / value.size).round(3)

      
      end
     results << hash
    end
    
    




    render json: results
  end
end
