function [Response] = exp_cues_treino(g,infos, aperture, disctexture,participant)

   
    % Hide mouse cursor
    HideCursor(infos.screen_num);
   
    % Open ResponsePixx
     ResponsePixx('Open');
  
    %%
    
    Response = zeros(48,6);
    bloco = 0;
    bloco2 = 0;
    abort = false;


try
    
    

for q = 1:infos.ntrials

    
    ble = 0;
    blee = 0;
    
    for vrau = 1:3
        if infos.show_noise_gabor(infos.SOA(q,1) + ble) == 1
            blee = blee + 1;
        end
        ble = ble + 1;
    end

    blee2 = abs(blee - 1);
         
    
    dotsize = repmat(infos.dotSize,infos.nrows,2);
    dotsize(infos.cue_onoff(q,1):infos.nrows,1) = infos.leftcuesize(q);
    dotsize(infos.cue_onoff(q,1):infos.nrows,2) = infos.rightcuesize(q);
    
    fp = repmat(WhiteIndex(infos.screenNumber),infos.nrows,1);
   
    orient                       = repmat(infos.orientation,infos.nrows,1);
    orient(infos.SOA(q,1):infos.SOA(q,4),1)     = infos.orienttarget(q,1);
    orient(infos.SOA(q,1):infos.SOA(q,4),2)     = infos.orienttarget(q,2);
    
    dclear                       = zeros(infos.nrows,1);
    dclear(infos.startgap(q))    = 1;
    dclear(infos.cue_onoff(q,1)) = 1;
    dclear(infos.cue_onoff(q,2)) = 1;
         
    centralcue = repmat(infos.grey,infos.nrows,1);
    centralcue(infos.cue_onoff(q,1):infos.nrows,1) = infos.black;
    
    
    HideCursor;
    load('filename.mat', 'noise');   
    
    %%
    
        if participant.tr == false % sujeito realiza a tarefa ja com os quatro blocos
    
            if q == 1 || q == infos.pausas2(1) ||  q == infos.pausas2(2) ||...
                      q == infos.pausas2(3)


            bloco2 = bloco2 + 1;


                if  infos.matrix(q,1) == 1
                    DrawFormattedText(infos.win,...
                    sprintf('Bloco %i.\n\n ---------------- \n\n Pista PERIFERICA \n\n Condição de SACADA',...
                    bloco2),'center', 'center', infos.black);   
                elseif infos.matrix(q,1) == 2
                    DrawFormattedText(infos.win,...
                    sprintf('Bloco %i.\n\n ---------------- \n\n Pista PERIFERICA \n\n Condição de FIXACAO',...
                    bloco2),'center', 'center', infos.black); 
                elseif infos.matrix(q,1) == 3
                    DrawFormattedText(infos.win,...
                    sprintf('Bloco %i.\n\n ---------------- \n\n Pista CENTRAL \n\n Condição de SACADA',...
                    bloco2),'center', 'center', infos.black);   
                elseif infos.matrix(q,1) == 4
                    DrawFormattedText(infos.win,...
                    sprintf('Bloco %i.\n\n ---------------- \n\n Pista CENTRAL \n\n Condição de FIXACAO',...
                    bloco2),'center', 'center', infos.black); 
                end
            

             Screen('Flip', infos.win);



                % Wait for button press
                ResponsePixx('StartNow', 1, [0 1 0 0 0], 1);
                while 1
                    [buttonStates, ~, ~] = ResponsePixx('GetLoggedResponses', 1, 1, 2000);
                        if ~isempty(buttonStates)
                            if buttonStates(1,2) == 1 % yellow button
                                break;
                            elseif buttonStates(1,4) == 1 % blue button | sai do exp
                                abort = true;
                                break
                            end
                        end
                end
                ResponsePixx('StopNow', 1, [0 0 0 0 0], 0);
             end

            if abort == true
                break;
            end
            
         end

   
     %%
      
     
    tic;
    % Desenha os placeholders e pf na tela por 500 ms
    Screen('BlendFunction', infos.win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    Screen('DrawDots',infos.win,infos.fpointcoord,infos.dotSize2,infos.black,[],2,1);
    Screen('DrawDots',infos.win,infos.fpointcoord,infos.dotSize,infos.white,[],2,1);
    Screen('DrawDots',infos.win,infos.pholdercoordL,infos.dotSize,infos.pholdercolor,[],2,1);
    Screen('DrawDots',infos.win,infos.pholdercoordR,infos.dotSize,infos.pholdercolor,[],2,1);
    Screen('Flip', infos.win);
    WaitSecs(0.5);
    
    
    %%
    
    ResponsePixx('StartNow', 1, [1 0 1 0 0], 1);
    for b = 1:infos.loops
        now = GetSecs();   
             
        % 1 segundo apresenta��o placeholders, pf, noise/gabor
        texL=Screen('MakeTexture',infos.win,noise(b + blee2,1).noiseimg,[],infos.flags);
        texR=Screen('MakeTexture',infos.win,noise(b + blee2,2).noiseimg,[],infos.flags);
        
        
            % Pista central 
        if infos.matrix(q,1) == 3 || infos.matrix(q,1) == 4
            if infos.matrix(q,2) == 1
                Screen('DrawLine', infos.win, centralcue(b), infos.xcenter,infos.ycenter ...
                ,infos.xcenter - 26,infos.ycenter, 4);
            else
                 Screen('DrawLine', infos.win, centralcue(b), infos.xcenter,infos.ycenter ...
                ,infos.xcenter + 26,infos.ycenter, 4);
            end
        end
        
        
        if infos.show_noise_gabor(b) == 1

            Screen('BlendFunction', infos.win, GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
            Screen('DrawTextures', infos.win, texL, [],infos.coordL,...
            orient(b,1),infos.filtmode,infos.galpha, [], [],...
            kPsychDontDoRotation, g(b).propertiesMat');
            Screen('DrawTextures', infos.win,[aperture disctexture],...
            [], infos.coordL, [], 0, [],infos.grey);

            Screen('BlendFunction', infos.win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            Screen('DrawTextures', infos.win, texR, [], infos.coordR, orient(b,2),...
            infos.filtmode, infos.galpha, [], [], kPsychDontDoRotation, g(b).propertiesMat');
            Screen('DrawTextures', infos.win, [aperture disctexture],...
            [], infos.coordR, [], 0,[],infos.grey);
                 
        else 
            if b <= infos.SOA(q,4)
                texL = g.gabortex; texR = g.gabortex;
                Screen('BlendFunction', infos.win, 'GL_ONE', 'GL_ZERO');
                Screen('DrawTextures', infos.win, texL, [], infos.coordL,...
                orient(b,1),0,1,[],[], kPsychDontDoRotation, g(b).propertiesMat');
                Screen('DrawTextures', infos.win, texR, [], infos.coordR,...
                orient(b,2), 0,1,[],[],kPsychDontDoRotation, g(b).propertiesMat');
            
            else % apos a aprsentacao do alvo, apenas os noises continuam sendo apresentados
                
                Screen('BlendFunction', infos.win, GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
                Screen('DrawTextures', infos.win, texL, [],infos.coordL,...
                orient(b,1),infos.filtmode,infos.galpha, [], [],...
                kPsychDontDoRotation, g(b).propertiesMat');
                Screen('DrawTextures', infos.win,[aperture disctexture],...
                [], infos.coordL, [], 0, [],infos.grey);

                Screen('BlendFunction', infos.win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
                Screen('DrawTextures', infos.win, texR, [], infos.coordR, orient(b,2),...
                infos.filtmode, infos.galpha, [], [], kPsychDontDoRotation, g(b).propertiesMat');
                Screen('DrawTextures', infos.win, [aperture disctexture],...
                [], infos.coordR, [], 0,[],infos.grey);
            end
            
        end

        
        Screen('BlendFunction', infos.win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        Screen('DrawDots',infos.win,infos.fpointcoord,infos.dotSize2,infos.black,[],2,1);
        Screen('DrawDots',infos.win,infos.fpointcoord,infos.dotSize,fp(b),[],2);
        Screen('DrawDots', infos.win, infos.pholdercoordL, dotsize(b,1),...
        infos.pholdercolor, [], 2, 1);
        Screen('DrawDots', infos.win, infos.pholdercoordR, dotsize(b,2),...
        infos.pholdercolor, [], 2, 1);
       
       
       
       % Get stimuli presentation timings and send eyelink timing messages
       if b == infos.startgap(q)
           Screen('Flip', infos.win, now+participant.tempo, dclear(b));
           Response(q,2) = toc;
       elseif b == infos.cue_onoff(q,1)
           Screen('Flip', infos.win, now+participant.tempo, dclear(b));
            Response(q,3) = toc;
       elseif b == infos.cue_onoff(q,2)
           Screen('Flip', infos.win, now+participant.tempo, dclear(b));
           Response(q,4) = toc;
       elseif b == infos.SOA(q,1)
           Screen('Flip', infos.win, now+participant.tempo, dclear(b));
            Response(q,5) = toc; % inicio apresentacao do alvo
            WaitSecs(participant.tempo2);
       else
            Screen('Flip', infos.win, now+participant.tempo, dclear(b));
       end
       
        Response(q,6) = Response(q,5) - Response(q,3); % SOA
       
    end
    
    %%

            
    % Desenha os placeholders e pf na tela
    Screen('DrawDots',infos.win,infos.fpointcoord,infos.dotSize2,infos.black,[],2,1);
    Screen('DrawDots',infos.win,infos.fpointcoord,infos.dotSize,infos.white,[],2,1);
    Screen('DrawDots',infos.win,infos.pholdercoordL,infos.dotSize,infos.pholdercolor,[],2,1);
    Screen('DrawDots',infos.win,infos.pholdercoordR,infos.dotSize,infos.pholdercolor,[],2,1);
    Screen('Flip', infos.win);
   
    
    if participant.tr == false
        % Wait for button press
%         ResponsePixx('StartNow', 1, [1 0 1 0 0], 1);
        while 1
            [buttonStates, ~, ~] = ResponsePixx('GetLoggedResponses', 1, 1, 2000);
            if ~isempty(buttonStates)
                if buttonStates(1,1) == 1 % red button
                    Response(q,1) = 2;   % sentido horario
                    break;
                elseif buttonStates(1,3) == 1 % green button
                    Response(q,1) = 1; % sentido anti-horario
                    break;
                elseif buttonStates(1,4) == 1 % blue button | sai do exp
                    abort = true;
                    break
                end
            end
        end
        ResponsePixx('StopNow', 1, [0 0 0 0 0], 0);
        
    
        if abort == true
            break;
        end
    end
      
    if participant.tr == false


        % Desenha os placeholders e pf na tela
        Screen('DrawDots',infos.win,infos.fpointcoord,infos.dotSize2,infos.black,[],2,1);
        if Response(q,1) == infos.matrix(q,3) % feedback em azul se a resposta for correta
            Screen('DrawDots',infos.win,infos.fpointcoord,infos.dotSize,[0 0 1],[],2,1);
        else
            Screen('DrawDots',infos.win,infos.fpointcoord,infos.dotSize,infos.white,[],2,1);
        end
        Screen('DrawDots',infos.win,infos.pholdercoordL,infos.dotSize,infos.pholdercolor,[],2,1);
        Screen('DrawDots',infos.win,infos.pholdercoordR,infos.dotSize,infos.pholdercolor,[],2,1);
        Screen('Flip', infos.win);
        WaitSecs(0.7);
        
    else
        Screen('DrawDots',infos.win,infos.fpointcoord,infos.dotSize2,infos.black,[],2,1);
        Screen('DrawDots',infos.win,infos.fpointcoord,infos.dotSize,infos.white,[],2,1);
        Screen('DrawDots',infos.win,infos.pholdercoordL,infos.dotSize,infos.pholdercolor,[],2,1);
        Screen('DrawDots',infos.win,infos.pholdercoordR,infos.dotSize,infos.pholdercolor,[],2,1);
        Screen('Flip', infos.win);
        WaitSecs(0.7);
    end
    
    
    
               % 45 = esquerda (sentido anti-horario) | 315 = direita (sentido horario)
          
                % ResponsePixx color mapping
                %%% red    [1] = right
                %%% yellow [2] = front
                %%% green  [3] = left
                %%% blue   [4] = bottom
                %%% white  [5] = middle          
          
    if participant.tr == false
    
     if   q == infos.pausas(1) ||  q == infos.pausas(2) ||...
          q == infos.pausas(3)
     
        bloco = bloco + 1;
        
        DrawFormattedText(infos.win,...
        sprintf('%iº bloco completo.\n\n Pressione o botao amarelo para continuar',...
        bloco),'center', 'center', infos.black);   
        
        Screen('Flip', infos.win);
          

        % Wait for button press
        ResponsePixx('StartNow', 1, [0 1 0 0 0], 1);
        while 1
            [buttonStates, ~, ~] = ResponsePixx('GetLoggedResponses', 1, 1, 2000);
            if ~isempty(buttonStates)
                if buttonStates(1,2) == 1 % yellow button
                    break;
                elseif buttonStates(1,4) == 1 % blue button | sai do exp
                    abort = true;
                    break;
                end
            end
        end
        ResponsePixx('StopNow', 1, [0 0 0 0 0], 0);
                
     end    
         if abort == true
            break;
        end
     
    end
    clear Textures
    
    
   
    
    
end


    DrawFormattedText(infos.win,sprintf('Voce completou todos os blocos da sessao. \n\n Parabens!')...
        ,'center', 'center', infos.black);
    Screen('Flip', infos.win);


    ResponsePixx('Close');
  

    KbStrokeWait;

    Screen('Close', infos.win);
    FlushEvents;
    ListenChar(0);
    ShowCursor;
    Priority(0);

    toc;
catch
    % este comando � que vai permitir que voc� receba uma mensagem detalhada
    % sobre o erro detectado no script pela fun��o try-catch.
    psychrethrow(psychlasterror);


end


end