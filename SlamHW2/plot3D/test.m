% tic;
% % for i=1:30
% %     for j=1:1000
% %         a(i,j)=1;
% %     end
% % end
% a=ones(30,1000);
% a(1:30,1:30)
% % b=a;
% b=m(a);
% toc;

% tic
% syms s
% solve(s*2+8)
% toc



function [b]=m (a)

% for i=1:30
%     for j=1:1000
%         b(i,j)=a(i,j);
%     end
% end
b=a;

end



for i=1:2
    for j=1:3:4
        for k=1:7
        [s1,s2]=tri(c1(k,:)',c2(k,:)',R(j:j+2,:),t(i,:)');
        if s1<0 || s2<0 
            flag=0;
        end
        end
    if flag==1
        t_f=t(i,:)';
        R_f=R(j:j+2,:);
    end
    end
end