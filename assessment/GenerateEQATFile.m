function GenerateEQATFile(DT,NPTS,AccelHistory,filename)

fileID = fopen(filename,'w');
fprintf(fileID,'NPTS= %u, DT= %.5f SEC\n',NPTS,DT);
fprintf(fileID,'  %.7E  %.7E  %.7E  %.7E  %.7E\n',AccelHistory);
fclose(fileID);

end

