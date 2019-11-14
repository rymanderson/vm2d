"""
  `generateVTK(filename, points; lines, cells, point_data, path, num, time)`
Generates a vtk file with the given data. Written by Eduardo Alvarez.
  **Arguments**
  * `points::Array{Array{Float64,1},1}`     : Points to output.
  **Optional Arguments**
  * `lines::Array{Array{Int64,1},1}`  : line definitions. lines[i] contains the
                            indices of points in the i-th line.
  * `cells::Array{Array{Int64,1},1}`  : VTK polygons definiton. cells[i]
                            contains the indices of points in the i-th polygon.
  * `data::Array{Dict{String,Any},1}` : Collection of data point fields in the
                            following format:
                              data[i] = Dict(
                                "field_name" => field_name::String
                                "field_type" => "scalar" or "vector"
                                "field_data" => point_data
                              )
                            where point_data[i] is the data at the i-th point.
See `examples.jl` for an example on how to use this function.
"""
function generateVTK(filename::String, points;
                    lines::Array{Array{Int64,1},1}=Array{Int64,1}[],
                    cells::Array{Array{Int64,1},1}=Array{Int64,1}[],
                    point_data=nothing, cell_data=nothing,
                    num=nothing, time=nothing,
                    path="", comments="", _griddims::Int64=-1,
                    keep_points::Bool=false,
                    override_cell_type::Int64=-1)
  aux = num!=nothing ? ".$num" : ""
  ext = aux*".vtk"
  if path !=""
    _path = string(path, (path[end]!="/" ? "/" : ""))
  else
    _path = path
  end
  f = open(string(_path, filename, ext), "w")
  # HEADER
  header = "# vtk DataFile Version 4.0" # File version and identifier
  header = string(header, "\n", " ", comments) # Title
  header = string(header, "\n", "ASCII") # File format
  header = string(header, "\n", "DATASET UNSTRUCTURED_GRID")
  write(f, header)
  # TIME
  if time!=nothing
    line0 = "\nFIELD FieldData 1"
    line1 = "\nSIM_TIME 1 1 double"
    line2 = "\n$(time)"
    write(f, line0*line1*line2)
  end
  np = size(points)[1]
  nl = size(lines)[1]
  nc = size(cells)[1]
  _keep_points = keep_points || (nl==0 && nc==0)
  # POINTS
  write(f, string("\n", "POINTS ", np, " float"))
  for i in 1:np
    print(f, "\n", points[i][1], " ", points[i][2], " ", points[i][3])
  end
  # We do this to avoid outputting points as cells if outputting a Grid
  # or if we simply want to ignore points
  if _griddims!=-1 || !_keep_points
    auxnp = np
    np = 0
  end
  # CELLS
  auxl = size(lines)[1]
  for line in lines
    auxl += size(line)[1]
  end
  auxc = size(cells)[1]
  for cell in cells
    auxc += size(cell)[1]
  end
  write(f, "\n\nCELLS $(np+nl+nc) $(2*np+auxl+auxc)")
  for i in 1:np+nl+nc
    if i<=np
      pts = [i-1]
    elseif i<=np+nl
      pts = lines[i-np]
    else
      pts = cells[i-(nl+np)]
    end
    print(f, "\n", size(pts,1))
    for pt in pts
      print(f, " ", pt)
    end
  end
  write(f, "\n\nCELL_TYPES $(np+nl+nc)")
  for i in 1:np+nl+nc
    if i<=np
      tpe = 1
    elseif i<=np+nl
      tpe = 4
    else
      if override_cell_type==-1
        if _griddims!=-1
          if _griddims==1
            tpe = 3
          elseif _griddims==2
            tpe = 9
          elseif _griddims==3
            tpe = 12
          else
            error("Generation of VTK cells of $_griddims dimensions not implemented")
          end
        else
          tpe = 7
        end
      else
        tpe = override_cell_type
      end
    end
    print(f, "\n", tpe)
  end
  if _griddims!=-1 || !_keep_points
    np = auxnp
  end
  # POINT DATA
  if point_data!=nothing
      write(f, "\n\nPOINT_DATA $np")
  end
  _p_data = point_data!=nothing ? point_data : []
  for field in _p_data
    field_name = field["field_name"]
    field_type = field["field_type"]
    data = field["field_data"]
    if size(data)[1]!=np
      warn("Corrupted field $(field_name)! Field size != number of points.")
    end
    if field_type=="scalar"
      write(f, "\n\nSCALARS $field_name float\nLOOKUP_TABLE default")
      for entry in data
        print(f, "\n", entry)
      end
    elseif field_type=="vector"
      write(f, "\n\nVECTORS $field_name float")
      for entry in data
        print(f, "\n", entry[1], " ", entry[2], " ", entry[3])
      end
    else
      error("Unknown field type $(field_type).")
    end
  end
    # CELL DATA
    if cell_data!=nothing
        write(f, "\n\nCELL_DATA $nc")
    end
    _c_data = cell_data!=nothing ? cell_data : []
    for field in _c_data
      field_name = field["field_name"]
      field_type = field["field_type"]
      data = field["field_data"]
      if size(data)[1]!=nc
        warn("Corrupted field $(field_name)! Field size != number of cells.")
      end
      if field_type=="scalar"
        write(f, "\n\nSCALARS $field_name float\nLOOKUP_TABLE default")
        for entry in data
          print(f, "\n", entry)
        end
      elseif field_type=="vector"
        write(f, "\n\nVECTORS $field_name float")
        for entry in data
          print(f, "\n", entry[1], " ", entry[2], " ", entry[3])
        end
      else
        error("Unknown field type $(field_type).")
      end
    end
  close(f)
  return filename*ext*";"
end