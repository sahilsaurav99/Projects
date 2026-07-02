import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { PermissionsGuard } from '../auth/guards/permissions.guard';
import { RequirePermissions } from '../auth/decorators/permissions.decorator';
import { LmsSessionsService } from './lms-sessions.service';
import { CreateLmsSessionDto } from './dto/create-lms-session.dto';
import { ListLmsSessionsQueryDto } from './dto/list-lms-sessions.query';
import { UpdateLmsSessionDto } from './dto/update-lms-session.dto';

/**
 * LmsSessionsController
 *
 * Permission keys mirror the course-modules module:
 *   lms-sessions.read   | lms-sessions.create | lms-sessions.update
 *   lms-sessions.delete | lms-sessions.restore
 */
@ApiTags('LMS Sessions')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller({ path: 'lms-sessions', version: '1' })
export class LmsSessionsController {
  constructor(private readonly lmsSessions: LmsSessionsService) {}

  @Get()
  @RequirePermissions('lms-sessions.read')
  @ApiOperation({ summary: 'List LMS sessions (paginated, filterable).' })
  @ApiOkResponse({ description: 'Paginated list of LMS sessions.' })
  list(@Query() query: ListLmsSessionsQueryDto) {
    return this.lmsSessions.findAll(query);
  }

  @Get(':id')
  @RequirePermissions('lms-sessions.read')
  @ApiOperation({ summary: 'Get a single LMS session by id.' })
  findOne(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.lmsSessions.findOne(id);
  }

  @Post()
  @RequirePermissions('lms-sessions.create')
  @ApiOperation({ summary: 'Create a new LMS session.' })
  create(@Body() dto: CreateLmsSessionDto) {
    return this.lmsSessions.create(dto);
  }

  @Patch(':id')
  @RequirePermissions('lms-sessions.update')
  @ApiOperation({ summary: 'Update an LMS session (partial).' })
  update(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateLmsSessionDto,
  ) {
    return this.lmsSessions.update(id, dto);
  }

  @Delete(':id')
  @RequirePermissions('lms-sessions.delete')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Soft-delete an LMS session (sets deletedAt).' })
  remove(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.lmsSessions.remove(id);
  }

  @Post(':id/restore')
  @RequirePermissions('lms-sessions.restore')
  @ApiOperation({ summary: 'Restore a previously soft-deleted LMS session.' })
  restore(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.lmsSessions.restore(id);
  }
}
