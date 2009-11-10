allcub=[];
for i=1:18
    subj{i} = interpret_weights(subj{i},results{i});
    mask=get_mat(subj{i},'mask','epi_z_thresh0.05_1');
    cub=zeros(size(mask));
    for j=1:7
        map=get_mat(subj{i},'pattern',['impmap_' num2str(i)]);
        mask=get_mat(subj{i},'mask',['epi_z_thresh0.05_' num2str(i)]);
        thiscub=zeros(size(mask));
        thiscub(logical(mask))=sum(map');
        cub=cub+thiscub;
    end
    allcub=allcub+cub;
end
