function gt = SaveGT(I, anns)

[dimy,dimx,~] = size(I);
[columnsInImage rowsInImage] = meshgrid(1:dimx, 1:dimy);
gt = uint8(zeros(dimy,dimx));
obj_cnt = 0;

n=length(anns); if(n==0), return; end

if(~isfield(anns,'iscrowd')), [anns(:).iscrowd]=deal(0); end
if(~isfield(anns,'segmentation'))
    S={anns.bbox}; 
    for i=1:n, x=S{i}(1); w=S{i}(3); y=S{i}(2); h=S{i}(4);
        anns(i).segmentation={[x,y,x,y+h,x+w,y+h,x+w,y]}; 
    end; 
end

S={anns.segmentation};
for i=1:n
  if(anns(i).iscrowd)
    continue;
  end
  obj_cnt = obj_cnt + 1;
  if(isstruct(S{i}))
      M = double(MaskApi.decode(S{i}));      
      gt(M) = obj_cnt;
  else
      for j=1:length(S{i})
          P=S{i}{j}+.5; 
          flag = inpolygon(columnsInImage,rowsInImage,P(1:2:end),P(2:2:end));
          flag = reshape(flag,[dimy,dimx]);
          gt(flag==1) = obj_cnt;              
      end
  end
end

