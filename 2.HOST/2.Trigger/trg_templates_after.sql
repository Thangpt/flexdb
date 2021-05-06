CREATE OR REPLACE TRIGGER "TRG_TEMPLATES_AFTER"
  after insert or update or delete on templates  
  for each row
declare
  -- local variables here
  l_template_id      templates.code%type;
  l_is_new_scheduler boolean := false;
  l_scheduler_status templates_scheduler.status%type;
  l_last_start_date  date;
  l_next_run_date    date;
  l_create_date      date;
  l_count_M 		number;
begin

  if deleting then
    delete templates_scheduler
     where templates_scheduler.template_id = :old.code and  REPEAT_INTERVAL not in ('M', 'Y');
  end if;

  if :new.cycle <> :old.cycle or inserting then
  
    begin
      select template_id, status, last_start_date, create_date
        into l_template_id,
             l_scheduler_status,
             l_last_start_date,
             l_create_date
        from templates_scheduler
       where template_id = :new.code;
    
    exception
      when NO_DATA_FOUND then
        l_is_new_scheduler := true;
    end;
	   
    if :new.cycle = 'P' then
      update templates_scheduler
         set status = 'D', repeat_interval = 'P'
       where template_id = l_template_id;
    
      return;
    end if;
  
    if l_is_new_scheduler then
    
      if :new.cycle = 'D' then
        l_next_run_date := to_date(getcurrdate + 1, 'DD/MM/RRRR');
        /*          update templates_scheduler
          set repeat_interval = :new.cycle,
              next_run_date   = last_start_date + 1
        where template_id = l_template_id;*/
      elsif :new.cycle = 'M' then
      
        l_next_run_date := to_date(ADD_MONTHS(trunc(getcurrdate, 'MONTH'),1), 'DD/MM/RRRR'); --to_date(add_months(getcurrdate, 1), 'DD/MM/RRRR');
        /*          update templates_scheduler
          set repeat_interval = :new.cycle,
              next_run_date   = add_months(last_start_date, 1)
        where template_id = l_template_id;*/
      elsif :new.cycle = 'Y' then
        l_next_run_date := to_date(add_months(getcurrdate, 12),
                                   'DD/MM/RRRR');
        /*          update templates_scheduler
          set repeat_interval = :new.cycle,
              next_run_date   =  add_months(last_start_date, 12)
        where template_id = l_template_id;*/
      end if;
    
      insert into templates_scheduler
        (template_id, create_date, next_run_date, repeat_interval, status)
      values
        (:new.code, sysdate, l_next_run_date, :new.cycle, 'A');
    else
    
      if l_scheduler_status = 'R' then
        update templates_scheduler
           set repeat_interval = :new.cycle
         where template_id = l_template_id;
      else
      
        if l_last_start_date is null then
          l_last_start_date := l_create_date;
        end if;
      
        if :new.cycle = 'D' then
          l_next_run_date := l_last_start_date + 1;
          /*          update templates_scheduler
            set repeat_interval = :new.cycle,
                next_run_date   = last_start_date + 1
          where template_id = l_template_id;*/
        elsif :new.cycle = 'M' then
        
          l_next_run_date := add_months(l_last_start_date, 1);
          /*          update templates_scheduler
            set repeat_interval = :new.cycle,
                next_run_date   = add_months(last_start_date, 1)
          where template_id = l_template_id;*/
        elsif :new.cycle = 'Y' then
          l_next_run_date := add_months(l_last_start_date, 12);
          /*          update templates_scheduler
            set repeat_interval = :new.cycle,
                next_run_date   =  add_months(last_start_date, 12)
          where template_id = l_template_id;*/
        end if;
      
        update templates_scheduler
           set repeat_interval = :new.cycle,
               next_run_date   = to_date(trunc(l_next_run_date, 'DD'),
                                         'DD/MM/RRRR'),
               status          = 'A'
         where template_id = l_template_id;
      
      end if;
    
    end if;
  
  end if;

  --exception when others then

end TRG_TEMPLATES_AFTER;
/

