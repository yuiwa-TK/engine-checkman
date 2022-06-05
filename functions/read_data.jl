using DelimitedFiles

# 生データ処理のための関数
function read_rawdata(input::Input)
      function overwrite_header!(head_data)
       head=Array{String}(undef,14)
       head[1] = "ID num."
       head[2] = "Title"
       head[3] = "Date"
       head[4] = "Num of channel"
       head[5] = "Digital input"
       head[6] = "Sampling freq."
       head[7] = "Num of data(/CH)"
       head[8] = "Measurement time"
       head[9] = "Name of channel"
       head[10]= "ID of channel"
       head[11]= "Range"
       head[12]= "Calibration coef."
       head[13]= "Offset"
       head[14]= "unit"
       return head_data[1:14] = head
   end
   function exptime(rawdata::Matrix{Any})
       return rawdata[3,2]*"::"*rawdata[3,3]
   end
   function overwrite_calibration!(input::Input)
       return [input.calibration_coef,input.calibration_offset]
   end
   
   data     = Data()
   filename = input.workdir*input.filename
   rawdata  = readdlm(filename,',')
   
   # read header
   nrow_head = 14
   data.head = rawdata[1:nrow_head,1]
   data.head = overwrite_header!(data.head)

   # read condition (channel 数が増えるとここを書き換える)
   data.condition = string.(rawdata[1:nrow_head])
   data.condition[3] = exptime(rawdata)
   data.condition[12:13] .= string(overwrite_calibration!(input))

   # read time data
   data.time = rawdata[nrow_head+1:end,1]

   # read channel data(thrust)
   @show input.ch_thrust
   data.thrust = rawdata[nrow_head+1:end,input.ch_thrust+1]

   return data
end
