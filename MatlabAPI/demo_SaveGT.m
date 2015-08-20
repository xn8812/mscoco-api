
dataDir='/home/nxu/Data/mscoco'; dataType='val2014';
annFile=sprintf('%s/annotations/instances_%s.json',dataDir,dataType);
if(~exist('coco','var')), coco=CocoApi(annFile); end

cats = coco.loadCats(coco.getCatIds());
imgIds = coco.getImgIds();
rng(20);

for ii = 1:500
    imgId = imgIds(randi(length(imgIds)),1);

    img = coco.loadImgs(imgId);
    I = imread(sprintf('%s/images/%s/%s',dataDir,dataType,img.file_name));
    figure(1); imagesc(I); axis('image'); set(gca,'XTick',[],'YTick',[])

    annIds = coco.getAnnIds('imgIds',imgId,'catIds',[],'iscrowd',[]);
    anns = coco.loadAnns(annIds);
    coco.showAnns(anns);
    gt = SaveGT(I, anns);
    imwrite(gt,['../results/val/',img.file_name(1:end-4),'.png']);
end