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
   
   rawdata   = RawData()
   filename  = input.workdir*input.filename
   buffer    = readdlm(filename,',')
   
   # read header
   nrow_head = 14
   rawdata.head = buffer[1:nrow_head,1]
   rawdata.head = overwrite_header!(rawdata.head)

   # read condition (channel 数が増えるとここを書き換える)
   rawdata.condition = string.(buffer[1:nrow_head])
   rawdata.condition[3] = exptime(buffer)
   rawdata.condition[12:13] .= string(overwrite_calibration!(input))

   # read time data
   rawdata.time = buffer[nrow_head+1:end,1]

   # read channel data(thrust)
   @show input.ch_thrust
   rawdata.thrust = buffer[nrow_head+1:end,input.ch_thrust+1]

   return rawdata
end
